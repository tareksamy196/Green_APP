-- Insert into category
INSERT INTO `cantu`.`category` (`id`,`name`,`pic`) VALUES 
(1,'Electronics','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FElectronics.jpg?alt=media&token=e3caec23-cbc3-4904-b0f3-7ae2d16bffef'), 
(2,'TVs','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2F32669973_kuoq_k6bc_220712.jpg?alt=media&token=b98d97f5-5e10-44ee-86f7-9be7d7838bbd'),
(3,'Books','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2F24307396_6920933.jpg?alt=media&token=ec6a20cc-c7d9-4606-bc5b-56565ffce0ba'),
(4,'mobile & tablets','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2Fmobile%20%26%20tablets.jpeg?alt=media&token=cd501e50-b4d2-47be-baa2-79df06846a91'),
(5,'Phone Accessories','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FPhone%20Accessories.png?alt=media&token=81d6f442-013b-4c97-a8e8-18dec2e70542'),
(6,' Furniture','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FFurniture.jpeg?alt=media&token=44fd0b92-a2ab-422e-a65b-f5fbe447865f'),
(7,'Fashion','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FFashion.jpg?alt=media&token=e8c3441b-d0d9-417e-9101-a2e8e67a4f61'),
(8,'Fashion Accessories','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FFashion%20Accessories.jpeg?alt=media&token=a51df76c-e51f-45be-b676-9d52400ebc38'),
(9, 'Tools', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2Ftools.jpg?alt=media&token=6799d18d-0b24-4dc2-a363-af9da94242e2'), 
(10, 'Toys', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2Ftoys.jpg?alt=media&token=0a95e867-7f2e-4251-9db8-766c7e5e1d08'), 
(11, 'Sports', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FOIP%20(2).jpeg?alt=media&token=20a0a327-8ed6-44c0-9beb-1a2bfaad85b6'), 
(12, 'Beauty', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/category%2FBeauty.jpeg?alt=media&token=424d9d6a-6c24-4cad-98c5-3299abd42a6b'); 


-- Insert into brand
INSERT INTO `cantu`.`brand` (`name`, `category_id`) VALUES 
('Computer', 1),
('Dishwasher', 1),
('Radio', 1),
('Scanner', 1),
('Microwave', 1),
('printer', 1),
('Fan', 1),
('Fridges & freezers', 1),
('Dell', 1), 
('Bosch', 1), 
 ('Canon', 1), 
('HP', 1),

('Philips', 2), 
('LG', 2),
('Sony', 2),
('Samsung ', 2),
('TCL', 2),
('tornado ', 2),
('JAC', 2),
('Fresh', 2),
('sharp', 2),
('Toshiba', 2),
('unionaire', 2),
('iTel', 2),
('Panasonic', 2),

('Novel', 3),
('Penguin', 3),

('Xiaomi', 4), 
('Lenovo', 4), 
('Samsung', 4),
('Apple',4),
('Nokia ',4),
('Itel',4),
('Huawei',4),
('oppo',4),
('realme',4),
('Infinix',4),
('honor',4),
('vivo',4),

('Smart Watches',5),
('Power_Banks',5),
('headsets',5),
('cases&protections',5),
('cables',5),
('stands',5),
('Memory_cards',5),
('Chargers&Adapters',5),
('Bluetooth_Accessories',5),
('Sandisk', 5), 
('Logitech', 5),

('IKEA', 6), 
('Storage & Organization',6),
('rugs',6),
('Chairs',6),
('mirror',6),
('tables',6),
('Lighting',6),

('American Eagle',7),
('Clever',7),
('Defacto',7),
('CAESAR',7),
('LC Waikiki',7),
('ACTIV',7),
('diadora',7),
('adidas',7),
('H&M', 7), 
('Gucci', 7), 
('Nike', 7), 
('Puma', 7), 
('Reebok', 7), 

('sneakers&slippers',8),
('Bags&wallets',8),
('jewelry',8),
('Glasses & watches',8),
('Ray-Ban', 8), 
('Fossil', 8), 
('Rolex', 8);

-- Insert into users
INSERT INTO `cantu`.`users` (`name`, `email`, `password`) VALUES
('john_doe', 'john@example.com', 'password1'), 
('jane_doe', 'jane@example.com', 'password2'),
('tarek', 'tarek@cantu.com', 'cantu2024'),
('heba', 'heba@cantu.com', 'cantu2024'),
('mahmoud', 'mahmoud@cantu.com', 'cantu2024'),
('begad', 'begad@cantu.com', 'cantu2024'),
('ahmed', 'ahmed@cantu.com', 'cantu2024'), 
('sara', 'sara@cantu.com', 'cantu2024'), 
('omar', 'omar@cantu.com', 'cantu2024'), 
('salma', 'salma@cantu.com', 'cantu2024'), 
('adam', 'adam@cantu.com', 'cantu2024'), 
('eve', 'eve@cantu.com', 'cantu2024'), 
('alice', 'alice@cantu.com', 'password5'), 
('bob', 'bob@cantu.com', 'password6'), 
('charlie', 'charlie@cantu.com', 'password7'), 
('david', 'david@cantu.com', 'password8'), 
('emma', 'emma@cantu.com', 'password9'), 
('frank', 'frank@cantu.com', 'password10'), 
('george', 'george@cantu.com', 'password11'), 
('hannah', 'hannah@cantu.com', 'password12'), 
('ivan', 'ivan@cantu.com', 'password13'), 
('jack', 'jack@cantu.com', 'password14'), 
('karen', 'karen@cantu.com', 'password15'), 
('leo', 'leo@cantu.com', 'password16');


-- Insert into product request 
INSERT INTO `cantu`.`product_request` (`category_id`, `brand_id`, `name`, `price`,`quantity`, `description`, `pic`, `user_id`,`status`) VALUES 
(4, 4, 'Pixel 5', 699.99, 5, 'Google smartphone', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FPixel%205.jpeg?alt=media&token=c1665b20-d6cc-4607-8912-4dc99c584be8', 1, 'pending'), 
(3, 3, 'To Kill a Mockingbird', 8.99, 15, 'Classic novel by Harper Lee','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FTo%20Kill%20a%20Mockingbird.jpg?alt=media&token=f27faad6-b22b-42ca-b8c2-943027661320', 2, 'approved'),
(5, 5, 'Wireless Earbuds', 49.99, 10, 'Bluetooth earbuds', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FWireless%20Earbuds.jpeg?alt=media&token=2a34a98e-747c-4daa-8113-a6bec300a69d', 3, 'pending'),
(6, 6, 'Office Chair', 99.99, 7, 'Ergonomic office chair', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FOffice%20Chair.jpg?alt=media&token=3ba116b4-e28b-4845-8663-391e98555c13', 4, 'approved'),
(7, 7, 'Winter Coat', 89.99, 20, 'Warm winter coat', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FWinter%20Coat.jpeg?alt=media&token=882b7f9a-575e-49fd-b1ef-f675ce6adaf4', 5, 'pending'),
(8, 8, 'Sunglasses', 19.99, 25, 'Stylish sunglasses', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FSunglasses.jpeg?alt=media&token=8bffa514-4f93-4ff2-8c0b-ae79ec27c4c2', 6, 'approved'),
(9, 9, 'Cordless Drill', 79.99, 10, 'Powerful cordless drill', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FCordless%20Drill.jpeg?alt=media&token=94f94440-f0f3-4f5d-834b-8a3bffcd0dff', 7, 'pending'),
(10, 10, 'Board Game', 29.99, 12, 'Fun family board game', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FBoard%20Game.jpeg?alt=media&token=a1f2f066-6fe5-42a3-9fb6-094451f05c3c', 8, 'approved'),
(11, 11, 'Basketball', 24.99, 18, 'Official size basketball', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FOfficial%20size%20basketball.jpeg?alt=media&token=fa6de8c5-d7bd-4bc1-a2b3-b179fa90d0f3', 9, 'pending'),
(12, 12, 'Shampoo', 12.99, 30, 'Organic hair shampoo','https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FShampoo.jpeg?alt=media&token=176e5780-4015-4e74-89b4-d26f27139b7f', 10, 'approved'),
(4, 4, 'Galaxy S21', 799.99, 3,'Latest Samsung smartphone', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FGalaxy%20S21.jpeg?alt=media&token=5aa7f3e9-6d18-4d5e-a659-2ac636d67240', 1,'approved'), 
(3, 3, 'Moby Dick', 10.99,20, 'Classic novel by Herman Melville', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FMoby%20Dick.jpg?alt=media&token=71588dda-2ca2-455e-8223-3089bc27052a', 1,'approved');


-- Insert into product******
INSERT INTO `cantu`.`product` (`id`,`category_id`, `brand_id`, `name`, `price`, `quantity`, `description`, `pic`, `seller_id`, `request_id`) VALUES 
(1,4, 4, 'iPhone 13', 999.99, 5, 'Latest Apple smartphone', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FiPhone%2013.jpeg?alt=media&token=41cf6b42-34ba-4792-85d3-e0e3bf620c34', 3, 4), 
(2,2, 2, 'OLED TV', 1200.00, 2, 'High definition OLED TV', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FHigh%20definition%20OLED%20TV.jpeg?alt=media&token=c00f1400-9a3e-4910-92ae-7cb764de02e5', 4, 5), 
(3,3, 3, 'War and Peace', 14.99, 10, 'Classic novel by Leo Tolstoy', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FWar%20and%20Peace.jpeg?alt=media&token=2a06f7f9-a70d-44cb-b88c-baa70d3c26c0', 3, 6), 
(4,5, 5, 'Power Bank 10000mAh', 25.99, 15, 'Portable charger', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FPower%20Bank%2010000mAh.jpeg?alt=media&token=f70c742d-488b-42a3-ae6e-bf469c8a2ee9', 5, 7), 
(5,6, 6, 'Dining Table Set', 299.99, 1, 'Wooden dining table with 4 chairs', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FDining%20Table%20Set.jpeg?alt=media&token=c9c9d671-2e3f-4484-8d94-618c525f4dc7', 6, 8), 
(6,7, 7, 'Summer Dress', 49.99, 20, 'Light and breezy summer dress', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FSummer%20Dress.jpeg?alt=media&token=3aba70a5-74e9-49f8-a760-61839d6695c4', 7, 9), 
(7,8, 8, 'Leather Wallet', 29.99, 25, 'Genuine leather wallet', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FLeather%20Wallet.jpeg?alt=media&token=fdef75e7-f0f8-44f2-94c0-657e8ccc29f7', 8, 10), 
(8,1, 1, 'Gaming Laptop', 1599.99, 3, 'High performance gaming laptop', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FGaming%20Laptop.jpeg?alt=media&token=631de1f0-94b0-4a67-9c19-29f9a275c80c', 9, 11), 
(9,4, 4, 'Galaxy S21', 799.99,3, 'Latest Samsung smartphone', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FGalaxy%20S21.jpeg?alt=media&token=5aa7f3e9-6d18-4d5e-a659-2ac636d67240', 1,1), 
(10,3, 3, 'Moby Dick', 10.99, 20,'Classic novel by Herman Melville', 'https://firebasestorage.googleapis.com/v0/b/cantu-53347.appspot.com/o/products%2FMoby%20Dick.jpg?alt=media&token=71588dda-2ca2-455e-8223-3089bc27052a', 1,3);


-- Insert into wishlist
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
INSERT INTO `cantu`.`wishlist` () VALUES ();
-- Insert into users_has_wishlist
INSERT INTO `cantu`.`users_has_wishlist` (`users_id`, `wishlist_id`) VALUES 
(1, 1),
(2, 2), 
(3, 3), 
(5, 5),
(4, 6), 
(6, 7), 
(7, 8), 
(8, 9), 
(9, 10);

-- Insert into wishlist_has_product****
INSERT INTO `cantu`.`wishlist_has_product` (`wishlist_id`, `product_id`) VALUES 
(1, 1), 
(1, 2), 
(2, 3),
(2, 5), 
(2, 6), 
(3, 7), 
(3, 8), 
(4, 9), 
(4, 10);

-- Insert into cart
INSERT INTO `cantu`.`cart` (`user_id`) VALUES 
(1), 
(2), 
(3), 
(4), 
(5), 
(6), 
(7), 
(8), 
(9), 
(10);

-- Insert into cart_item
INSERT INTO `cantu`.`cart_item` (`cart_id`, `product_id`, `quantity`) VALUES 
(1, 1, 1), 
(1, 2, 2), 
(2, 3, 1), 
(2, 4, 1), 
(3, 5, 1), 
(3, 6, 2), 
(4, 7, 1), 
(4, 8, 3), 
(5, 9, 1), 
(5, 10, 2);

-- Insert into order
INSERT INTO `cantu`.`order` (`user_id`, `total_amount`, `status`, `address`) VALUES 
(1, 849.98, 'shipped', '123 Main St, Springfield'), 
(2, 18.98, 'delivered', '456 Elm St, Springfield'), 
(3, 99.98, 'shipped', '789 Oak St, Springfield'), 
(4, 299.97, 'processing', '101 Pine St, Springfield'), 
(5, 99.98, 'cancelled', '102 Maple St, Springfield');

-- Insert into order_item
INSERT INTO `cantu`.`order_item` (`order_id`, `product_id`, `quantity`, `price`) VALUES 
(1, 1, 1, 799.99), 
(1, 2, 1, 8.99), 
(2, 3, 1, 8.99), 
(2, 4, 1, 10.99), 
(3, 5, 1, 49.99), 
(3, 6, 1, 49.99), 
(4, 7, 3, 89.99), 
(5, 8, 2, 19.99);

-- Insert into payment
INSERT INTO `cantu`.`payment` (`order_id`, `amount`, `method`, `status`, `paid_at`) VALUES 
(1, 849.98, 'Credit Card', 'approved', '2024-06-28 10:00:00'), 
(2, 18.98, 'PayPal', 'approved', '2024-06-28 11:00:00'), 
(3, 99.98, 'Credit Card', 'approved', '2024-06-28 12:00:00'), 
(4, 299.97, 'Credit Card', 'approved', '2024-06-28 13:00:00'), 
(5, 99.98, 'PayPal', 'approved', '2024-06-28 14:00:00');

-- Insert into review
INSERT INTO `cantu`.`review` (`user_id`, `product_id`, `rating`, `comment`) VALUES 
(1, 1, 5, 'Great product!'), 
(2, 2, 4, 'Very good book.'), 
(3, 3, 3, 'Average quality.'), 
(4, 4, 5, 'Excellent chair.'), 
(5, 5, 2, 'Not as expected.'), 
(6, 6, 4, 'Good value for money.'), 
(7, 7, 3, 'Okay product.'), 
(8, 8, 5, 'Loved it!'), 
(9, 9, 4, 'Works well.'), 
(10, 10, 5, 'Highly recommended!');