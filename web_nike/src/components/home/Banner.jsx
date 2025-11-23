import React from "react";
import Buttom from "../btn/Buttom";

const Banner = () => {
  return (
    <>
      <div className="flex flex-col items-center justify-center pb-10">
        <img src="/src/assets/banner/banner.png" alt="" className="" />
        <h2 className="text-xl font-medium pt-5">First Look</h2>
        <h2 className="font-medium text-6xl">Nike Air Max Pulse</h2>
        <p className="text-sm py-5">
          Extreme comfort. Hyper durable. Max volume. Introducing the Air Max
          Pulse <br /> —designed to push you past your limits and help you go to
          the max.
        </p>
        <div className="  flex gap-5">
          <Buttom text="Notify Me" />
          <Buttom text="Shop Air Max" />
        </div>
      </div>
    </>
  );
};

export default Banner;
