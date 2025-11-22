import React from "react";
import { Link } from "react-router-dom";
import { IoLogoTwitter } from "react-icons/io";
import { FaFacebookF } from "react-icons/fa";
import { TfiYoutube } from "react-icons/tfi";
import { TiSocialInstagram } from "react-icons/ti";
import { IoLocationSharp } from "react-icons/io5";

const listFooter = [
  {
    name: "FIND A STORE",
    link: "/",
    list: [
      { name: "Become A Member", link: "/" },
      { name: "Sign Up for Email", link: "/" },
      { name: "Send Us Feedback", link: "/" },
      { name: "Student Discounts", link: "/" },
    ],
  },
  {
    name: "Get Help",
    link: "/",
    list: [
      { name: "Order Status", link: "/" },
      { name: "Delivery", link: "/" },
      { name: "Returns", link: "/" },
      { name: "Payment Options", link: "/" },
      { name: "Contact Us On Nike.com Inquiries", link: "/" },
      { name: "Contact Us On All Other Inquiries", link: "/" },
    ],
  },
  {
    name: "About Nike",
    link: "/",
    list: [
      { name: "News", link: "/" },
      { name: "Careers", link: "/" },
      { name: "Investors", link: "/" },
      { name: "Sustainability", link: "/" },
    ],
  },
];

const listIcons = [
  { icon: <IoLogoTwitter />, link: "/" },
  { icon: <FaFacebookF />, link: "/" },
  { icon: <TfiYoutube />, link: "/" },
  { icon: <TiSocialInstagram />, link: "/" },
];

const link = [
  { name: "Guides", link: "/" },
  { name: "Terms of Sale", link: "/" },
  { name: "Terms of Use", link: "/" },
  { name: "Nike Privacy Policy", link: "/" },
];

const Footer = () => {
  return (
    <footer>
      <div className="bg-[#111111] px-15 py-7">
        <div className="flex justify-between gap-10 ">
          <div className="flex">
            {listFooter.map((e, i) => (
              <div key={i} className=" text-white">
                <div className="pr-40">
                  <div>
                    <h3 className="font-normal mb-4">{e.name}</h3>
                    <ul className="flex flex-col gap-2">
                      {e.list.map((item, index) => (
                        <li
                          key={index}
                          className={`font-normal mb-4 ${
                            !i == 0 ? "text-[#7E7E7E]" : ""
                          }`}
                        >
                          <Link to={item.link}>
                            {!i == 0
                              ? item.name
                              : item.name.toLocaleUpperCase()}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            ))}
          </div>
          <div className="flex items-start gap-3">
            {listIcons.map((e, i) => (
              <div className="bg-[#7E7E7E] p-2 flex items-center justify-center rounded-full ">
                <Link key={i} to={e.link} className="text-2xl">
                  {e.icon}
                </Link>
              </div>
            ))}
          </div>
        </div>
        <div className="flex justify-between">
          <div className="flex items-end justify-center gap-10 ">
            <div className="text-white flex items-center gap-2 mt-10">
              <IoLocationSharp className="text-white" />
              India
            </div>
            <div className="text-[#7E7E7E]">
              © 2023 Nike, Inc. All Rights Reserved
            </div>
          </div>
          <div className="flex gap-5 text-[#7E7E7E] mt-2">
            {link.map((e, i) => (
              <div key={i}>
                <Link to={e.link}>{e.name}</Link>
              </div>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
