const express = require('express');
const router = express.Router();
const TrainingProgress = require('../models/training.model');
const { authenticateToken } = require('../middleware/auth.middleware');

const PET_MODULES = {
  Dog: [
    'basic_commands',
    'leash_training',
    'house_training',
    'socialization',
    'advanced_commands',
    'trick_training',
    'behavior_modification'
  ],
  Cat: [
    'litter_training',
    'scratching_post',
    'basic_commands'
  ],
  Bird: [
    'step_up',
    'target_training',
    'speech_training'
  ]
};

// GET /api/training/progress/:petType - Retrieve progress
router.get('/progress/:petType', authenticateToken, async (req, res) => {
  try {
    const userId = req.user._id;
    const { petType } = req.params;

    if (!PET_MODULES[petType]) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pet type. Must be Dog, Cat, or Bird.'
      });
    }

    let progress = await TrainingProgress.findOne({ userId, petType });

    if (!progress) {
      // Create new progress record
      const firstModule = PET_MODULES[petType][0];
      progress = new TrainingProgress({
        userId,
        petType,
        completedModules: [],
        unlockedModules: [firstModule],
        streak: 0,
        lastActiveDate: null,
        badges: []
      });
      await progress.save();
    }

    res.json({
      success: true,
      data: progress
    });
  } catch (error) {
    console.error('Error fetching training progress:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve training progress',
      error: error.message
    });
  }
});

// POST /api/training/complete/:petType - Mark module as completed
router.post('/complete/:petType', authenticateToken, async (req, res) => {
  try {
    const userId = req.user._id;
    const { petType } = req.params;
    const { moduleId } = req.body;

    if (!moduleId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required field: moduleId'
      });
    }

    const modulesList = PET_MODULES[petType];
    if (!modulesList) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pet type. Must be Dog, Cat, or Bird.'
      });
    }

    let progress = await TrainingProgress.findOne({ userId, petType });

    if (!progress) {
      const firstModule = modulesList[0];
      progress = new TrainingProgress({
        userId,
        petType,
        completedModules: [],
        unlockedModules: [firstModule],
        streak: 0,
        lastActiveDate: null,
        badges: []
      });
    }

    // 1. Add to completed if not already there
    if (!progress.completedModules.includes(moduleId)) {
      progress.completedModules.push(moduleId);
    }

    // 2. Calculate streak updates
    const now = new Date();
    const lastActive = progress.lastActiveDate;
    let streakIncremented = false;

    if (!lastActive) {
      // First active day
      progress.streak = 1;
      streakIncremented = true;
    } else {
      const msDiff = now.getTime() - lastActive.getTime();
      const hoursDiff = msDiff / (1000 * 60 * 60);

      if (hoursDiff > 36) {
        // More than 36 hours has passed, reset streak
        progress.streak = 1;
        streakIncremented = true;
      } else if (hoursDiff >= 12 && hoursDiff <= 36) {
        // Active on the next day (between 12 and 36 hours limit)
        progress.streak += 1;
        streakIncremented = true;
      } else {
        // Less than 12 hours, keep current streak (already active today)
      }
    }
    progress.lastActiveDate = now;

    // 3. Unlock the next module in sequence
    const currentIndex = modulesList.indexOf(moduleId);
    if (currentIndex !== -1 && currentIndex < modulesList.length - 1) {
      const nextModuleId = modulesList[currentIndex + 1];
      if (!progress.unlockedModules.includes(nextModuleId)) {
        progress.unlockedModules.push(nextModuleId);
      }
    }

    // 4. Evaluate Badge triggers
    const newlyUnlockedBadges = [];

    // Badge A: First Steps (completed first module ever)
    const hasFirstSteps = progress.badges.some(b => b.id === 'first_steps');
    if (!hasFirstSteps && progress.completedModules.length >= 1) {
      const badge = {
        id: 'first_steps',
        title: 'First Steps',
        description: 'Completed your very first training module!'
      };
      progress.badges.push(badge);
      newlyUnlockedBadges.push(badge);
    }

    // Badge B: Streak Master (streak reaches 3 days)
    const hasStreakMaster = progress.badges.some(b => b.id === 'streak_master');
    if (!hasStreakMaster && progress.streak >= 3) {
      const badge = {
        id: 'streak_master',
        title: 'Streak Master',
        description: 'Maintained a training streak for 3 consecutive days!'
      };
      progress.badges.push(badge);
      newlyUnlockedBadges.push(badge);
    }

    // Badge C: Pet Graduate (completed all modules of this petType)
    const hasGraduate = progress.badges.some(b => b.id === `${petType.toLowerCase()}_graduate`);
    const allCompleted = modulesList.every(m => progress.completedModules.includes(m));
    if (!hasGraduate && allCompleted) {
      const badge = {
        id: `${petType.toLowerCase()}_graduate`,
        title: `${petType} Graduate`,
        description: `Successfully completed all training lessons for your ${petType}!`
      };
      progress.badges.push(badge);
      newlyUnlockedBadges.push(badge);
    }

    await progress.save();

    res.json({
      success: true,
      message: 'Module completion saved',
      data: progress,
      newlyUnlockedBadges
    });
  } catch (error) {
    console.error('Error updating training progress:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update training progress',
      error: error.message
    });
  }
});

module.exports = router;
