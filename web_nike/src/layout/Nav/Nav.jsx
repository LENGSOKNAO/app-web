import React from "react";
import { Link } from "react-router-dom";
import { CiSearch } from "react-icons/ci";

const Nav = () => {
  const NavLink = [
    { name: "Find a Store", link: "/" },
    { name: "Help", link: "/ " },
    { name: "Join Us", link: "/  " },
    { name: "Sign In", link: "/ " },
  ];

  const NavBar = [
    { name: "New & Featured", link: "/" },
    { name: "Men", link: "/ " },
    { name: "Women", link: "/  " },
    { name: "Kids", link: "/ " },
    { name: "Sale", link: "/ " },
    { name: "SNKRS", link: "/ " },
  ];

  return (
    <nav className="">
      {/* Navigation link */}
      <div className="flex justify-between items-center p-4 bg-[#F5F5F5] px-10">
        <div className="">
          <img src="/src/assets/smallLogo.png" alt="Logo" />
        </div>
        <div className="flex gap-2">
          {NavLink.map((e, i) => (
            <div
              key={i}
              className={`flex items-center justify-center gap-2 font-medium ${
                !i == 0
                  ? " before:content-[''] before:w-[1px] before:h-[14px] before:bg-black"
                  : ""
              } `}
            >
              <Link to={e.link}> {e.name} </Link>
            </div>
          ))}
        </div>
      </div>
      {/* Navigation Bar */}
      <div className="flex justify-between px-10">
        {/* logo */}
        <div className="">
          <img src="/src/assets/logo.png" alt="" />
        </div>
        {/* list */}
        <div className="flex gap-5 items-center font-normal text-[16px]">
          {NavBar.map((e, i) => (
            <div key={i} className="">
              <Link to={e.link}> {e.name} </Link>
            </div>
          ))}
        </div>
        {/* icon */}
        <div className="flex gap-4 items-center">
          <div className="flex items-center bg-[#F5F5F5] py-[6px] px-[8px] rounded-4xl w-[180px] ">
            <CiSearch className="text-3xl" />
            <input
              className="w-full pl-4 border-none outline-none font-medium "
              type="text"
              placeholder="Search"
            />
          </div>
          <img src="/src/assets/icon/bag.png" alt="" />
          <img src="/src/assets/icon/favorite.png" alt="" />
        </div>
      </div>
    </nav>
  );
};

export default Nav;
