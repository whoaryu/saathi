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
  },
  // Additional 30 pets
  {
    name: "Daisy",
    type: "Dog",
    breed: "Beagle",
    age: 2,
    description: "A curious and friendly Beagle with an excellent sense of smell. Great for families who love outdoor activities.",
    location: "Nashville",
    imageUrl: "https://images.unsplash.com/photo-1507146426996-ef05306b0a2e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Oliver",
    type: "Cat",
    breed: "British Shorthair",
    age: 4,
    description: "A calm and dignified British Shorthair with round eyes and plush fur. Perfect for apartment living.",
    location: "San Francisco",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Buddy",
    type: "Dog",
    breed: "Poodle",
    age: 3,
    description: "An intelligent and hypoallergenic Poodle who loves to learn tricks. Great for families with allergies.",
    location: "Phoenix",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Sophie",
    type: "Cat",
    breed: "Ragdoll",
    age: 1,
    description: "A gentle Ragdoll cat that goes limp when picked up. Very affectionate and great with children.",
    location: "Las Vegas",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Cooper",
    type: "Dog",
    breed: "Border Collie",
    age: 2,
    description: "A highly intelligent Border Collie who loves to herd and work. Perfect for active families.",
    location: "Salt Lake City",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Nala",
    type: "Cat",
    breed: "Bengal",
    age: 3,
    description: "A wild-looking Bengal cat with beautiful spotted coat. Very active and loves to climb.",
    location: "Orlando",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Tucker",
    type: "Dog",
    breed: "Corgi",
    age: 4,
    description: "A short-legged Corgi with a big personality. Loves to herd and is very loyal to his family.",
    location: "Dallas",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Milo",
    type: "Cat",
    breed: "Russian Blue",
    age: 2,
    description: "A shy but loving Russian Blue with beautiful silver-blue fur. Great for quiet homes.",
    location: "Minneapolis",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Rex",
    type: "Dog",
    breed: "Rottweiler",
    age: 5,
    description: "A strong and protective Rottweiler who is very loyal to his family. Great guard dog.",
    location: "Detroit",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Cleo",
    type: "Cat",
    breed: "Egyptian Mau",
    age: 1,
    description: "A graceful Egyptian Mau with spotted coat and green eyes. Very fast and loves to play.",
    location: "New Orleans",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Finn",
    type: "Dog",
    breed: "Husky",
    age: 3,
    description: "A beautiful Husky with striking blue eyes. Loves cold weather and has lots of energy.",
    location: "Anchorage",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Zoe",
    type: "Cat",
    breed: "Abyssinian",
    age: 2,
    description: "An active Abyssinian with ticked coat. Very intelligent and loves to explore.",
    location: "San Diego",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Bear",
    type: "Dog",
    breed: "Saint Bernard",
    age: 4,
    description: "A gentle giant Saint Bernard who loves children. Great for families with lots of space.",
    location: "Denver",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Loki",
    type: "Cat",
    breed: "Norwegian Forest Cat",
    age: 3,
    description: "A large Norwegian Forest Cat with thick fur. Very independent and loves to climb trees.",
    location: "Seattle",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Atlas",
    type: "Dog",
    breed: "Great Dane",
    age: 2,
    description: "A massive Great Dane who thinks he's a lap dog. Very gentle despite his size.",
    location: "Indianapolis",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Pixel",
    type: "Cat",
    breed: "Sphynx",
    age: 1,
    description: "A hairless Sphynx cat who loves to cuddle for warmth. Very affectionate and social.",
    location: "Miami",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Thor",
    type: "Dog",
    breed: "Mastiff",
    age: 5,
    description: "A powerful Mastiff with a heart of gold. Excellent guard dog and family protector.",
    location: "Cleveland",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Nova",
    type: "Cat",
    breed: "Turkish Van",
    age: 2,
    description: "A beautiful Turkish Van with white coat and colored tail. Loves water and swimming.",
    location: "Tampa",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Zeus",
    type: "Dog",
    breed: "Doberman",
    age: 3,
    description: "A sleek Doberman with natural ears and tail. Very intelligent and loyal to his family.",
    location: "Kansas City",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Stella",
    type: "Cat",
    breed: "Scottish Fold",
    age: 4,
    description: "A cute Scottish Fold with folded ears. Very sweet and loves to sit in unusual positions.",
    location: "Pittsburgh",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Apollo",
    type: "Dog",
    breed: "Siberian Husky",
    age: 2,
    description: "A stunning Siberian Husky with thick fur and blue eyes. Loves to run and pull sleds.",
    location: "Fairbanks",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Maya",
    type: "Cat",
    breed: "Burmese",
    age: 1,
    description: "A social Burmese cat who loves to be around people. Very vocal and affectionate.",
    location: "Austin",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Bruno",
    type: "Dog",
    breed: "Boxer",
    age: 4,
    description: "A playful Boxer with lots of energy. Great with kids and loves to play fetch.",
    location: "Columbus",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Iris",
    type: "Cat",
    breed: "Himalayan",
    age: 3,
    description: "A beautiful Himalayan with long fur and blue eyes. Very calm and loves to be groomed.",
    location: "Portland",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Koda",
    type: "Dog",
    breed: "Australian Shepherd",
    age: 2,
    description: "A smart Australian Shepherd with beautiful merle coat. Loves to work and herd.",
    location: "Boise",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Phoenix",
    type: "Cat",
    breed: "Oriental Shorthair",
    age: 1,
    description: "A sleek Oriental Shorthair with large ears. Very active and loves to play with toys.",
    location: "Albuquerque",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Ranger",
    type: "Dog",
    breed: "Bernese Mountain Dog",
    age: 3,
    description: "A gentle Bernese Mountain Dog with tri-color coat. Great family dog and loves cold weather.",
    location: "Burlington",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Sage",
    type: "Cat",
    breed: "American Shorthair",
    age: 4,
    description: "A classic American Shorthair with silver tabby coat. Very healthy and low maintenance.",
    location: "Madison",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Winston",
    type: "Dog",
    breed: "English Bulldog",
    age: 5,
    description: "A wrinkly English Bulldog with lots of personality. Very loyal and great with children.",
    location: "Richmond",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Aurora",
    type: "Cat",
    breed: "Ragdoll",
    age: 2,
    description: "A beautiful Ragdoll with blue eyes and pointed coat. Very gentle and loves to be held.",
    location: "Spokane",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Chief",
    type: "Dog",
    breed: "Alaskan Malamute",
    age: 3,
    description: "A powerful Alaskan Malamute with thick fur. Loves to pull sleds and work in cold weather.",
    location: "Anchorage",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Luna",
    type: "Cat",
    breed: "Balinese",
    age: 1,
    description: "A graceful Balinese with long silky fur. Very vocal and loves to be the center of attention.",
    location: "Honolulu",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Titan",
    type: "Dog",
    breed: "Newfoundland",
    age: 4,
    description: "A massive Newfoundland who loves water. Excellent swimmer and great with children.",
    location: "Portland",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Misty",
    type: "Cat",
    breed: "Russian Blue",
    age: 3,
    description: "A shy Russian Blue with silver-blue fur and green eyes. Very gentle and loves quiet homes.",
    location: "Seattle",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Blaze",
    type: "Dog",
    breed: "Rhodesian Ridgeback",
    age: 2,
    description: "A sleek Rhodesian Ridgeback with distinctive ridge on back. Great hunting dog and loyal companion.",
    location: "Nashville",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Coco",
    type: "Cat",
    breed: "Chocolate Point Siamese",
    age: 1,
    description: "A beautiful Chocolate Point Siamese with dark brown points. Very vocal and loves to chat.",
    location: "Miami",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Storm",
    type: "Dog",
    breed: "Belgian Malinois",
    age: 3,
    description: "A highly intelligent Belgian Malinois used in police work. Very active and needs lots of exercise.",
    location: "Phoenix",
    imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Pearl",
    type: "Cat",
    breed: "White Persian",
    age: 4,
    description: "A stunning white Persian with long fluffy fur. Very calm and loves to be pampered.",
    location: "Los Angeles",
    imageUrl: "https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Rex",
    type: "Dog",
    breed: "German Shorthaired Pointer",
    age: 2,
    description: "A versatile German Shorthaired Pointer with spotted coat. Excellent hunting dog and family pet.",
    location: "Dallas",
    imageUrl: "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Sapphire",
    type: "Cat",
    breed: "Blue Point Siamese",
    age: 3,
    description: "A beautiful Blue Point Siamese with blue-gray points. Very social and loves to be around people.",
    location: "Chicago",
    imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Atlas",
    type: "Dog",
    breed: "Irish Wolfhound",
    age: 5,
    description: "A massive Irish Wolfhound, the tallest dog breed. Very gentle despite his size and great with families.",
    location: "Boston",
    imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
  },
  {
    name: "Ruby",
    type: "Cat",
    breed: "Red Tabby Persian",
    age: 2,
    description: "A beautiful red tabby Persian with long fur and distinctive markings. Very affectionate and calm.",
    location: "San Francisco",
    imageUrl: "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
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