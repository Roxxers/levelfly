# Property of Levelfly. All rights reserved. Date: 2014-02-07

task :load_wardrobe => :environment do

  Reward.delete_all("target_type = 'wardrobe'")
  WardrobeItem.delete_all("depth = 2 and item_type <> 'head' and item_type <> 'hair' and item_type <> 'facial_hair'")
  Wardrobe.delete_all("name <> 'Basic'")


  # === Basic ===
  Wardrobe.unlock_lvl('Basic', 1)
  Wardrobe.add('Basic', 'Accessories', 'Jewelry', 'Hoop Earrings', 'earrings', 'basic/earrings/earring_large_ring', 0)
  Wardrobe.add('Basic', 'Accessories', 'Jewelry', 'Pearl Earrings', 'earrings', 'basic/earrings/earring_white', 1)
  Wardrobe.add('Basic', 'Accessories', 'Jewelry', 'Orange Earrings', 'earrings', 'basic/earrings/earring_orange', 2, 'Gold Earrings')
  Wardrobe.add('Basic', 'Accessories', 'Jewelry', 'Orange Necklace', 'necklace', 'basic/necklace/necklace_orange', 3, 'Gold Necklace')
  Wardrobe.add('Basic', 'Accessories', 'Hobbies', 'Guitar', 'prop', 'basic/props/guitar_black', 0, 'Electric Guitar')
  Wardrobe.add('Basic', 'Accessories', 'Misc', 'Gray Gloves', 'prop', 'basic/glove/glove_gray', 0)
  Wardrobe.add('Basic', 'Accessories', 'Misc', 'Pink Teddy Bear', 'prop', 'basic/props/pink_teddy', 1)
  Wardrobe.add('Basic', 'Accessories', 'Gadgets', 'Camera', 'prop', 'basic/props/camera', 0)
  Wardrobe.add('Basic', 'Accessories', 'Bags', 'Handbag', 'prop', 'basic/props/hand_bag', 0)
  Wardrobe.add('Basic', 'Accessories', 'Bags', 'Leather Bag', 'prop', 'basic/props/leather_bag', 1, 'Leather Briefcase')
  Wardrobe.add('Basic', 'Accessories', 'Bags', 'Messenger Bag', 'prop', 'basic/props/side_bag', 2)
  Wardrobe.add('Basic', 'Body', 'Casual', 'Black-T', 'top', 'basic/tops/black_t', 0, 'Black T')
  Wardrobe.add('Basic', 'Body', 'Casual', 'Blue Polo', 'top', 'basic/tops/polo_short_sleeve_blue', 1)
  Wardrobe.add('Basic', 'Body', 'Casual', 'Short Buttoned Blue Shirt', 'top', 'basic/tops/shirt_short_sleeve_cyan', 2, 'Blue Button Up')
  Wardrobe.add('Basic', 'Body', 'Casual', 'Short Buttoned Pink Shirt', 'top', 'basic/tops/shirt_short_sleeve_pink', 3, 'Pink Button Up')
  Wardrobe.add('Basic', 'Body', 'Career', 'Lab Coat', 'top', 'basic/tops/doctor_white_top', 0)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Black Tux', 'top', 'basic/tops_dressy/black_bow', 0)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Black Suit', 'top', 'basic/tops_dressy/dark_gray_tie', 1, 'Dark Gray Suit')
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Black Dress', 'top', 'basic/tops_dressy/black_maroon_short_dress', 2, 'Black Maroon Dress')
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Brown Dress', 'top', 'basic/tops_dressy/brown_dress', 3)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Orange Dress', 'top', 'basic/tops_dressy/orange_short_dress', 4)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'Red Dress', 'top', 'basic/tops_dressy/red_long_dress', 5)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'White Dress 3', 'top', 'basic/tops_dressy/white_short_dress', 6, 'White Dress 1')
  Wardrobe.add('Basic', 'Body', 'Dressy', 'White Dress 2', 'top', 'basic/tops_dressy/white_dress', 7)
  Wardrobe.add('Basic', 'Body', 'Dressy', 'White Dress', 'top', 'basic/tops_dressy/black_white_long_dress', 8, 'White Dress 3')
  Wardrobe.add('Basic', 'Body', 'Misc', 'Cowboy', 'top', 'basic/tops/cowboy_top_with_court', 0, 'Cowboy Jacket')
  Wardrobe.add('Basic', 'Body', 'Sporty', 'Football', 'top', 'basic/tops/american_football_top', 0, 'Football Top')
  Wardrobe.add('Basic', 'Body', 'Sporty', 'Baseball', 'top', 'basic/tops/baseball_t_shirt', 1, 'Baseball Top')
  Wardrobe.add('Basic', 'Feet', 'Career', 'Army', 'shoes', 'basic/shoes/army_boot', 0, 'Army Boots')
  Wardrobe.add('Basic', 'Feet', 'Sporty', 'Football', 'shoes', 'basic/shoes/american_football_shoe', 0, 'Football Cleats')
  Wardrobe.add('Basic', 'Feet', 'Sporty', 'Baseball', 'shoes', 'basic/shoes/baseball_shoe', 1, 'Baseball Cleats')
  Wardrobe.add('Basic', 'Feet', 'Misc', 'Cowboy', 'shoes', 'basic/shoes/cowboy_boot', 0, 'Cowboy Boots')
  Wardrobe.add('Basic', 'Feet', 'Misc', 'Purple Power', 'shoes', 'basic/shoes/purple_superhero_boot', 1, 'Black Boots')
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'Black', 'shoes', 'basic/shoes/black_shoe', 0, 'Black Shoes')
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'Black Heels', 'shoes', 'basic/shoes/black_heels', 1, 'Black Heels 2')
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'White Heels', 'shoes', 'basic/shoes/white_heels_1', 2, 'White Heels 1')
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'White Heels 2', 'shoes', 'basic/shoes/white_heels_2', 3)
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'Red Heels', 'shoes', 'basic/shoes/red_heels', 4)
  Wardrobe.add('Basic', 'Feet', 'Dressy', 'Pink Heels', 'shoes', 'basic/shoes/shoe_pink', 5)
  Wardrobe.add('Basic', 'Feet', 'Casual', 'Brown Slippers', 'shoes', 'basic/shoes/slippers_brown', 0)
  Wardrobe.add('Basic', 'Feet', 'Casual', 'Purple Slippers', 'shoes', 'basic/shoes/slippers_purple', 1)
  Wardrobe.add('Basic', 'Feet', 'Casual', 'Grey Sneakers', 'shoes', 'basic/shoes/sneakers_gray', 2, 'Gray Sneakers')
  Wardrobe.add('Basic', 'Feet', 'Casual', 'Purple Sneakers', 'shoes', 'basic/shoes/sports_shoe_purple', 3)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 1', 'face', 'basic/face/asian_male', 0)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 2', 'face', 'basic/face/asian_female', 1)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 3', 'face', 'basic/face/chinese_male', 2)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 4', 'face', 'basic/face/chinese_female', 3)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 5', 'face', 'basic/face/african_male', 4)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 6', 'face', 'basic/face/african_female', 5)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 7', 'face', 'basic/face/latin_male', 6)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 8', 'face', 'basic/face/latin_female', 7)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 9', 'face', 'basic/expression/angry_1', 8)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 10', 'face', 'basic/expression/angry_2', 9)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 11', 'face', 'basic/expression/angry_3', 10)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 12', 'face', 'basic/expression/angry_4', 11)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 13', 'face', 'basic/expression/smile_1', 12)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 14', 'face', 'basic/expression/smile_2', 13)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 15', 'face', 'basic/expression/smile_3', 14)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 16', 'face', 'basic/expression/smile_4', 15)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 17', 'face', 'basic/expression/winking_1', 16)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 18', 'face', 'basic/expression/winking_2', 17)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 19', 'face', 'basic/expression/winking_3', 18)
  Wardrobe.add('Basic', 'Head', 'Face', 'Face 20', 'face', 'basic/expression/winking_4', 19)
  Wardrobe.add('Basic', 'Head', 'Misc', 'Black Cap', 'hat', 'basic/hats/hat_red_black', 0)
  Wardrobe.add('Basic', 'Legs', 'Sporty', 'Football', 'bottom', 'basic/bottoms/american_football_pant', 0, 'Football Bottom')
  Wardrobe.add('Basic', 'Legs', 'Sporty', 'Baseball', 'bottom', 'basic/bottoms/baseball_pant', 1, 'Baseball Bottom')
  Wardrobe.add('Basic', 'Legs', 'Misc', 'Purple Power', 'bottom', 'basic/bottoms/purple_superhero_bottom', 0, 'Purple Tights')
  Wardrobe.add('Basic', 'Legs', 'Casual', 'Black Skinny Jeans', 'bottom', 'basic/bottoms/black_tight_jean', 0)
  Wardrobe.add('Basic', 'Legs', 'Casual', 'Long Denim', 'bottom', 'basic/bottoms/trousers_long_denim_blue', 1, 'Blue Jeans')
  Wardrobe.add('Basic', 'Legs', 'Casual', 'Short Denim', 'bottom', 'basic/bottoms/trousers_short_denim_blue', 2, 'Denim Shorts')
  Wardrobe.add('Basic', 'Legs', 'Career', 'Army', 'bottom', 'basic/bottoms/trouser_army', 0, 'Army Fatigues')
  Wardrobe.add('Basic', 'Legs', 'Dressy', 'Grey Trousers', 'bottom', 'basic/bottoms/gray_brown_long_trouser', 0, 'Gray Trousers')
  Wardrobe.add('Basic', 'Legs', 'Dressy', 'Short Brown Skirt', 'bottom', 'basic/bottoms/skirt_short_brown', 1)
  Wardrobe.add('Basic', 'Legs', 'Dressy', 'Short Pink Skirt', 'bottom', 'basic/bottoms/skirt_short_pink', 2)

  # === BMCC ===
  Wardrobe.unlock_lvl('BMCC', 2)
  Wardrobe.add('BMCC', 'Body', 'Casual', 'BMCC 1', 'tops', 'bmcc/tops/bmcc_blue', 4)
  Wardrobe.add('BMCC', 'Body', 'Casual', 'BMCC 2', 'tops', 'bmcc/tops/bmcc_light_gray', 5)
  Wardrobe.add('BMCC', 'Body', 'Casual', 'BMCC 3', 'tops', 'bmcc/tops/bmcc_small_logo', 6)
  Wardrobe.add('BMCC', 'Body', 'Casual', 'BMCC 4', 'tops', 'bmcc/tops/bmcc_yellow_small_logo', 7)

  # === Basketball ===
  Wardrobe.unlock_lvl('Basketball', 3)
  Wardrobe.add('Basketball', 'Body', 'Sporty', 'Basketball Jersey', 'tops', 'basketball/tops/basketball_t_shirt', 2)
  Wardrobe.add('Basketball', 'Feet', 'Sporty', 'Basketball Shoes', 'shoes', 'basketball/shoes/basketball_shoe', 2)
  Wardrobe.add('Basketball', 'Legs', 'Sporty', 'Basketball Shorts', 'bottom', 'basketball/bottoms/basketball_short', 2)

  # === Urban Chic ===
  Wardrobe.unlock_lvl('Urban Chic', 4)
  Wardrobe.add('Urban Chic', 'Accessories', 'Jewelry', 'Nosestud', 'earrings', 'urban_chic/earrings/nose_stud', 4, 'Nose Stud')
  Wardrobe.add('Urban Chic', 'Accessories', 'Misc', 'Sunglasses', 'prop', 'urban_chic/glasses/shade_black', 2)

  # === Superhero ===
  Wardrobe.unlock_lvl('Superhero', 5)
  Wardrobe.add('Superhero', 'Body', 'Misc', 'Purple Power', 'top', 'superhero/tops/purple_superhero_top', 1, 'Superhero')

  # === Cowboy ===
  Wardrobe.unlock_lvl('Cowboy', 6)
  Wardrobe.add('Cowboy', 'Body', 'Misc', 'Cowboy Vest', 'top', 'cowboy/tops/cowboy_top_without_court', 2)
  Wardrobe.add('Cowboy', 'Head', 'Misc', 'Cowboy', 'hat', 'cowboy/hats/cowboy_hat', 1, 'Cowboy Hat')
  Wardrobe.add('Cowboy', 'Legs', 'Misc', 'Cowboy Chaps', 'bottom', 'cowboy/bottoms/cowboy_bottom', 1)

  # === Skater ===
  Wardrobe.unlock_lvl('Skater', 7)
  Wardrobe.add('Skater', 'Accessories', 'Hobbies', 'Skateboard', 'prop', 'skater/props/skateboard', 1)
  Wardrobe.add('Skater', 'Accessories', 'Gadgets', 'Headphones', 'prop', 'skater/props/headphone', 1)

  # === Doctor ===
  Wardrobe.unlock_lvl('Doctor', 8)
  Wardrobe.add('Doctor', 'Accessories', 'Misc', 'Stethoscope', 'prop', 'doctor/props/stethoscope', 3)

  # === Business ===
  Wardrobe.unlock_lvl('Business', 9)
  Wardrobe.add('Business', 'Body', 'Dressy', 'Red Tie', 'top', 'business/tops/red_tie_shirt_long_sleeve', 9)
  Wardrobe.add('Business', 'Body', 'Dressy', 'Argyle Sweater', 'top', 'business/tops/shirt_long_sleeve_with_jacket', 10)
  Wardrobe.add('Business', 'Body', 'Dressy', 'Blue Tie', 'top', 'business/tops/tie_shirt_long_sleeve_yellow', 11)
  Wardrobe.add('Business', 'Legs', 'Dressy', 'Brown Trousers', 'bottom', 'business/bottoms/trousers_long_brown', 3)

  # === Army ===
  Wardrobe.unlock_lvl('Army', 10)
  Wardrobe.add('Army', 'Body', 'Career', 'Army Shirt 1', 'top', 'army/tops/shirt_army', 1)
  Wardrobe.add('Army', 'Body', 'Career', 'Army Shirt 2', 'top', 'army/tops/t_shirt_army', 2)

  # === Jewelry ===
  Wardrobe.unlock_lvl('Jewelry', 11)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Sapphire Earrings', 'earrings', 'jewelry/earrings/earring_blue', 5)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Ruby Earrings', 'earrings', 'jewelry/earrings/earring_red', 6)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Silver Drop Earrings', 'earrings', 'jewelry/earrings/earring_silver_1', 7)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Silver Stud Earrings', 'earrings', 'jewelry/earrings/earring_silver_2', 8)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Silver Necklace 1', 'necklace', 'jewelry/necklace/necklace_silver_1', 9)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Silver Necklace 2', 'necklace', 'jewelry/necklace/necklace_silver_2', 10)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Diamond Necklace 1', 'necklace', 'jewelry/necklace/necklace_diamond_1', 11)
  Wardrobe.add('Jewelry', 'Accessories', 'Jewelry', 'Diamond Necklace 2', 'necklace', 'jewelry/necklace/necklace_diamond_2', 12)

  # === Pirate ===
  Wardrobe.unlock_lvl('Pirate', 12)
  Wardrobe.add('Pirate', 'Legs', 'Misc', 'Pirate Bottom', 'bottom', 'pirate/bottoms/pirate_bottom', 2)
  Wardrobe.add('Pirate', 'Feet', 'Misc', 'Pirate Boots', 'shoes', 'pirate/shoes/pirate_boot', 2)
  Wardrobe.add('Pirate', 'Body', 'Misc', 'Pirate Top', 'top', 'pirate/tops/pirate_top', 3)
  Wardrobe.add('Pirate', 'Head', 'Misc', 'Pirate Hat 2', 'hat', 'pirate/hats/pirate_hat', 2)

  # === Shirt ===
  Wardrobe.unlock_lvl('Shirt', 13)
  Wardrobe.add('Shirt', 'Body', 'Casual', 'Pink Flower Print', 'top', 'shirt/tops/pink_sleeveless_shirt', 8)
  Wardrobe.add('Shirt', 'Body', 'Casual', 'Gray Polo', 'top', 'shirt/tops/short_sleeve_gray', 9)

  # === Referee ===
  Wardrobe.unlock_lvl('Referee', 14)
  Wardrobe.add('Referee', 'Body', 'Career', 'Referee Shirt', 'top', 'referee/tops/referee_t_shirt', 3)

  # === Golfer ===
  Wardrobe.unlock_lvl('Golfer', 15)
  Wardrobe.add('Golfer', 'Body', 'Sporty', 'Golf Shirt Blue', 'top', 'golfer/tops/golf_t_shirt_blue', 3)
  Wardrobe.add('Golfer', 'Body', 'Sporty', 'Golf Shirt Pink', 'top', 'golfer/tops/golf_t_shirt_pink', 4)
  Wardrobe.add('Golfer', 'Feet', 'Sporty', 'Golf Shoes', 'shoes', 'golfer/shoes/golf_shoe', 3)
  Wardrobe.add('Golfer', 'Head', 'Misc', 'Golf Hat', 'hat', 'golfer/hats/golf_hat_white', 3)
  Wardrobe.add('Golfer', 'Legs', 'Sporty', 'Golf Shorts', 'bottom', 'golfer/bottoms/golf_short', 3)

  # === Sports Equipment ===
  Wardrobe.unlock_lvl('Sports Equipment', 16)
  Wardrobe.add('Sports Equipment', 'Accessories', 'Hobbies', 'Football', 'prop', 'sports_equipment/props/american_football', 2)
  Wardrobe.add('Sports Equipment', 'Accessories', 'Hobbies', 'Baseball Bat', 'prop', 'sports_equipment/props/baseball_bat', 3)
  Wardrobe.add('Sports Equipment', 'Accessories', 'Hobbies', 'Basketball', 'prop', 'sports_equipment/props/basketball', 4)
  Wardrobe.add('Sports Equipment', 'Accessories', 'Hobbies', 'Golf Stick', 'prop', 'sports_equipment/props/golf_stick', 5)

  # === Policeman ===
  Wardrobe.unlock_lvl('Policeman', 17)
  Wardrobe.add('Policeman', 'Body', 'Career', 'Police Top', 'top', 'policeman/tops/police_top', 4)

  # === Farmer ===
  Wardrobe.unlock_lvl('Farmer', 18)
  Wardrobe.add('Farmer', 'Body', 'Career', 'Farmer Overalls', 'top', 'farmer/tops/farmer_tops', 5)

  # === Tees ===
  Wardrobe.unlock_lvl('Tees', 19)
  Wardrobe.add('Tees', 'Body', 'Casual', 'Purple T', 'top', 'tees/tops/short_sleeve_purple', 10)
  Wardrobe.add('Tees', 'Body', 'Casual', 'Gray T', 'top', 'tees/tops/short_sleeve_tattoo', 11)
  Wardrobe.add('Tees', 'Body', 'Casual', 'Skinny Black T', 'top', 'tees/tops/skinny_black', 12)

  # === Hiker ===
  Wardrobe.unlock_lvl('Hiker', 20)
  Wardrobe.add('Hiker', 'Body', 'Sporty', 'Hiker Top', 'top', 'hiker/tops/hiking_jacket_red', 5)
  Wardrobe.add('Hiker', 'Feet', 'Sporty', 'Hiking Shoes', 'shoes', 'hiker/shoes/hiking_shoe', 4)

  # === Spanish Dancer ===
  Wardrobe.unlock_lvl('Spanish Dancer', 21)
  Wardrobe.add('Spanish Dancer', 'Body', 'Misc', 'Dancer Jacket', 'top', 'spanish_dancer/tops/spanish_top', 4)
  Wardrobe.add('Spanish Dancer', 'Body', 'Misc', 'Dancer Blouse', 'top', 'spanish_dancer/tops/spanish_women_red_top', 5)

  # === Instrument ===
  Wardrobe.unlock_lvl('Instrument', 22)
  Wardrobe.add('Instrument', 'Accessories', 'Hobbies', 'Bongo Drum', 'prop', 'instrument/props/bongo_drum', 6)
  Wardrobe.add('Instrument', 'Accessories', 'Hobbies', 'Acoustic Guitar', 'prop', 'instrument/props/guitar_brown', 7)
  Wardrobe.add('Instrument', 'Accessories', 'Hobbies', 'Saxophone', 'prop', 'instrument/props/saxophone', 8)

  # === Devil ===
  Wardrobe.unlock_lvl('Devil', 23)
  Wardrobe.add('Devil', 'Accessories', 'Misc', 'Red Gloves', 'prop', 'devil/glove/devil_glove', 4)
  Wardrobe.add('Devil', 'Accessories', 'Misc', 'Pitchfork', 'prop', 'devil/props/pitchfork', 5)
  Wardrobe.add('Devil', 'Body', 'Misc', 'Devil Vest', 'top', 'devil/tops/devil_shirt', 6)
  Wardrobe.add('Devil', 'Body', 'Misc', 'Devil Dress', 'top', 'devil/tops_misc/devil_short_dress', 7)
  Wardrobe.add('Devil', 'Feet', 'Misc', 'Devil Boots', 'shoes', 'devil/shoes/devil_boot', 3)
  Wardrobe.add('Devil', 'Head', 'Misc', 'Devil Horns', 'hat', 'devil/hats/devil_horns', 4)
  Wardrobe.add('Devil', 'Legs', 'Misc', 'Devil Trousers', 'bottom', 'devil/bottoms/trouser_devil', 3)

  # === Witch ===
  Wardrobe.unlock_lvl('Witch', 24)
  Wardrobe.add('Witch', 'Accessories', 'Misc', 'Broom', 'prop', 'witch/props/broom', 6)
  Wardrobe.add('Witch', 'Body', 'Misc', 'Witch Dress', 'top', 'witch/tops_misc/witch_black_dress', 8)

  # === Body Art ===
  Wardrobe.unlock_lvl('Body Art', 25)
  Wardrobe.add('Body Art', 'Accessories', 'Misc', 'Tattoo', 'prop', 'body_art/tattoo/tattoo', 7)
  Wardrobe.add('Body Art', 'Head', 'Misc', 'Mole', 'prop', 'body_art/facial_marks/mole', 5)
  Wardrobe.add('Body Art', 'Head', 'Misc', 'Red Lipstick', 'prop', 'body_art/makeup/makeup_red_lips', 6)

  # === Santa ===
  Wardrobe.unlock_lvl('Santa', 26)
  Wardrobe.add('Santa', 'Body', 'Misc', 'Santa', 'top', 'santa/tops/santa_top', 9, 'Santa Top')
  Wardrobe.add('Santa', 'Head', 'Misc', 'Santa Hat', 'hat', 'santa/hats/santa_hat', 7)
  Wardrobe.add('Santa', 'Legs', 'Misc', 'Santa', 'bottom', 'santa/bottoms/santa_trouser', 4, 'Santa Bottom')

  Admin.reset_rewards
end
