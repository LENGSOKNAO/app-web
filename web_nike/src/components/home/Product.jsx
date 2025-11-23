import React, { useState, useRef } from "react";
import {
  MdOutlineKeyboardArrowLeft,
  MdOutlineKeyboardArrowRight,
} from "react-icons/md";

const Product = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const sliderRef = useRef(null);

  const products = [
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: "$120",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike Air Force 1",
      category: "Men's Shoes",
      price: "$110",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike Dunk Low",
      category: "Unisex Shoes",
      price: "$100",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike Jordan 1",
      category: "Basketball Shoes",
      price: "$170",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike Blazer",
      category: "Lifestyle Shoes",
      price: "$85",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike React Infinity",
      category: "Running Shoes",
      price: "$160",
      image: "src/assets/product/product.png",
    },
    {
      name: "Nike Metcon",
      category: "Training Shoes",
      price: "$130",
      image: "src/assets/product/product.png",
    },
  ];

  const itemsToShow = 4;
  const maxIndex = Math.max(0, products.length - itemsToShow);

  const nextSlide = () => {
    setCurrentIndex((prevIndex) => (prevIndex >= maxIndex ? 0 : prevIndex + 1));
  };

  const prevSlide = () => {
    setCurrentIndex((prevIndex) => (prevIndex <= 0 ? maxIndex : prevIndex - 1));
  };

  // Calculate transform for smooth sliding
  const getTransform = () => {
    const itemWidth = 100 / itemsToShow; // Percentage per item
    return `translateX(-${currentIndex * itemWidth}%)`;
  };

  return (
    <div className="p-6 bg-white">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-gray-900">Best of Air Max</h2>
        <div className="flex items-center gap-2">
          <span className="text-lg font-medium text-gray-700">Shop</span>
          <div className="flex gap-2">
            <button
              onClick={prevSlide}
              className={`${
                currentIndex === maxIndex
                  ? "bg-blue-500 hover:bg-blue-600 text-white"
                  : "bg-gray-200 hover:bg-gray-300 text-gray-800"
              } text-2xl rounded-full p-2 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-gray-400`}
              aria-label="Previous products"
            >
              <MdOutlineKeyboardArrowLeft />
            </button>
            <button
              onClick={nextSlide}
              className="bg-gray-200 hover:bg-gray-300 text-gray-800 text-2xl rounded-full p-2 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-gray-400"
              aria-label="Next products"
            >
              <MdOutlineKeyboardArrowRight />
            </button>
          </div>
        </div>
      </div>

      <div className="relative overflow-hidden">
        <div
          ref={sliderRef}
          className="flex transition-transform duration-500 ease-in-out"
          style={{ transform: getTransform() }}
        >
          {products.map((product, index) => (
            <div
              key={index}
              className="flex-shrink-0 px-3"
              style={{ width: `${100 / itemsToShow}%` }}
            >
              <div className="bg-gray-50 rounded-lg p-4 hover:shadow-lg transition-shadow duration-300">
                <div className="aspect-square mb-4 overflow-hidden rounded-lg">
                  <img
                    src={product.image}
                    alt={product.name}
                    className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                  />
                </div>
                <h3 className="font-semibold text-gray-900 text-lg mb-1 line-clamp-2">
                  {product.name}
                </h3>
                <p className="text-gray-600 text-sm mb-2">{product.category}</p>
                <p className="text-gray-900 font-bold text-lg">
                  {product.price}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Optional: Dots indicator */}
      <div className="flex justify-center mt-6 gap-2">
        {Array.from({ length: maxIndex + 1 }).map((_, index) => (
          <button
            key={index}
            onClick={() => setCurrentIndex(index)}
            className={`w-2 h-2 rounded-full transition-all duration-300 ${
              index === currentIndex ? "bg-gray-800 w-4" : "bg-gray-300"
            }`}
            aria-label={`Go to slide ${index + 1}`}
          />
        ))}
      </div>
    </div>
  );
};

export default Product;
