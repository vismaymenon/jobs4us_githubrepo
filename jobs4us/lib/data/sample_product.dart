import '../models/product.dart';

final Product sampleProduct = Product(
  id: '1',
  name: 'Notebook',
  description: 'A 80-page notebook for writing whatever you wish.',
  price: 5.0,
  stock: 5,
  imageUrls: [
    'https://i5.walmartimages.com/seo/Pen-Gear-1-Subject-Notebook-College-Ruled-Blue-70-Sheets_f975b2c5-e2c7-4162-aac7-a37b2dedf74e.2b6ff69c4be5f87b5e27cab260872e90.jpeg',
    'https://i5.walmartimages.com/asr/213e0a9d-e743-444a-b3d9-a418dc7d08ac.595232b2d8c30d00b6731a5f4b72b453.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF',
    'https://i5.walmartimages.com/asr/bae2ade7-97c2-4aed-a093-c17297d9604d.254d7df36e95ee9f14d9b0c0b44619f9.jpeg?odnHeight=160&odnWidth=160&odnBg=FFFFFF',
  ],
  category: 'Stationery',
  discount: 0.0,
  brand: 'XYZ',
);