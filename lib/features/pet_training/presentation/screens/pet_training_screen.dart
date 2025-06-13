import 'package:flutter/material.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
import 'package:saathi/features/pet_training/presentation/screens/base_training_screen.dart';

class PetTrainingScreen extends BaseTrainingScreen {
  PetTrainingScreen({super.key})
      : super(
          petType: 'Dog',
          modules: List.from(TrainingModule.modules),
          petIcon: Icons.pets,
          primaryColor: Colors.blue,
        );
} 