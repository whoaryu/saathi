const mongoose = require('mongoose');
require('dotenv').config();

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/saathi')
  .then(() => console.log('✅ Connected to MongoDB'))
  .catch(err => console.error('❌ MongoDB connection error:', err));

// Pet Schema (matching your backend model)
const petSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, required: true },
  breed: { type: String, required: true },
  age: { type: Number, required: true },
  description: { type: String, required: true },
  location: { type: String, required: true },
  imageUrl: { type: String, required: true },
  isAdopted: { type: Boolean, default: false },
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  adoptionRequests: [{ type: mongoose.Schema.Types.ObjectId, ref: 'AdoptionRequest' }],
}, { timestamps: true });

const Pet = mongoose.model('Pet', petSchema);

const samplePets = [
  {
    name: "Max",
    type: "Dog",
    breed: "German Shepherd",
    age: 3,
    description: "A loyal and intelligent German Shepherd who loves to protect his family. Great with kids and very trainable.",
    location: "Los Angeles",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Luna",
    type: "Cat",
    breed: "Persian",
    age: 1,
    description: "A beautiful Persian cat with long fluffy fur. She's very calm and loves to be pampered. Perfect for a quiet home.",
    location: "Chicago",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Charlie",
    type: "Dog",
    breed: "Labrador Retriever",
    age: 4,
    description: "An energetic and friendly Labrador who loves swimming and playing fetch. Great family dog with lots of love to give.",
    location: "Miami",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Mittens",
    type: "Cat",
    breed: "Siamese",
    age: 2,
    description: "A vocal and affectionate Siamese cat. She loves to chat and will follow you around the house. Very social and playful.",
    location: "Seattle",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Rio",
    type: "Bird",
    breed: "African Grey Parrot",
    age: 1,
    description: "A smart and talkative African Grey Parrot. He can mimic sounds and loves to interact with people. Perfect for bird lovers.",
    location: "Austin",
    imageUrl: "https://images.unsplash.com/photo-1552728089-57bdde30beb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Rocky",
    type: "Dog",
    breed: "Bulldog",
    age: 5,
    description: "A gentle giant Bulldog with a heart of gold. Despite his tough appearance, he's very sweet and loves to cuddle.",
    location: "Boston",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Shadow",
    type: "Cat",
    breed: "Maine Coon",
    age: 3,
    description: "A majestic Maine Coon with beautiful long fur. He's very gentle and loves to be brushed. Great with other pets.",
    location: "Portland",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Bella",
    type: "Dog",
    breed: "Golden Retriever",
    age: 2,
    description: "A sweet and gentle Golden Retriever who loves everyone she meets. Perfect therapy dog material with her calm nature.",
    location: "Denver",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  }
];

async function addPets() {
  try {
    console.log('🐕 Adding sample pets directly to database...\n');
    
    // First, let's get a user ID to use as owner (or create a default one)
    const User = mongoose.model('User', new mongoose.Schema({}));
    let defaultUser = await User.findOne();
    
    if (!defaultUser) {
      // Create a default user if none exists
      defaultUser = new User({
        name: "Sample User",
        email: "sample@example.com"
      });
      await defaultUser.save();
      console.log('👤 Created default user for pet ownership');
    }
    
    for (let i = 0; i < samplePets.length; i++) {
      const petData = samplePets[i];
      try {
        console.log(`📝 Adding ${petData.name} (${petData.breed})...`);
        
        const pet = new Pet({
          ...petData,
          owner: defaultUser._id,
          adoptionRequests: []
        });
        
        await pet.save();
        console.log(`✅ Successfully added ${petData.name}!`);
        
      } catch (error) {
        console.log(`❌ Error adding ${petData.name}: ${error.message}`);
      }
    }
    
    console.log('\n🎉 Finished adding sample pets!');
    console.log('📱 Check your Flutter app to see the new pets!');
    
  } catch (error) {
    console.error('❌ Database error:', error);
  } finally {
    mongoose.connection.close();
  }
}

// Run the script
addPets(); 