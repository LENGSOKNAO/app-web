import React, { useRef, useState } from "react";
import { BsChevronLeft, BsChevronRight } from "react-icons/bs";
const SliderProduct = () => {
  const listProuct = [
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
    {
      name: "Nike Air Max Pulse",
      category: "Women's Shoes",
      price: 13995,
      image: "/src/assets/product/product.png",
    },
  ];

  const [items, setItems] = useState(0);
  const sliderRef = useRef(null);

  const itemShow = 4;
  const maxItem = Math.max(0, listProuct.length - itemShow);

  const next = () => {
    setItems((p) => (p >= maxItem ? 0 : p + 1));
  };

  const prev = () => {
    setItems((p) => (p <= 0 ? maxItem : p - 1));
  };

  const get = () => {
    const itemWidth = 100 / itemShow;
    return `translateX(-${items * itemWidth}%)`;
  };

  return (
    <div className="px-10">
      <div className="flex justify-between pb-5">
        <h1 className="text-lg font-medium ">Best of Air Max</h1>
        <div className="flex gap-2 items-center">
          <h1 className="text-sm font-medium">Shop</h1>
          <button
            onClick={prev}
            className="bg-gray-300 text-xl p-2 rounded-full"
          >
            <BsChevronLeft />
          </button>
          <button
            onClick={next}
            className="bg-gray-300 text-xl p-2 rounded-full"
          >
            <BsChevronRight />
          </button>
        </div>
      </div>
      <div className="relative overflow-hidden">
        <div
          ref={sliderRef}
          className="flex transition-transform duration-500 ease-in-out"
          style={{ transform: get() }}
        >
          {listProuct.map((e, i) => (
            <div
              key={i}
              className="shrink-0 pl-2"
              style={{ width: `${100 / itemShow}%` }}
            >
              <img src={e.image} className="object-cover w-full" alt="" />
              <div className="flex justify-between px-1 py-5">
                <div className="">
                  <h1 className="text-lg font-medium "> {e.name}</h1>
                  <div className="text-lg font-normal text-[#757575]">
                    {e.category}
                  </div>
                </div>
                <div className="text-lg font-medium">
                  ₹{Number(e.price).toLocaleString().replace(/,/g, " ")}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default SliderProduct;
