import React from "react";
import { Link } from "react-router-dom";

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

const Footer = () => {
  return (
    <footer>
      <div className="bg-[#111111] flex gap-10 px-5">
        {listFooter.map((e, i) => (
          <div key={i} className=" text-white py-10 px-5">
            <div className="">
              <div>
                <h3 className="font-normal mb-3">{e.name}</h3>
                <ul className="flex flex-col gap-2">
                  {e.list.map((item, index) => (
                    <li
                      key={index}
                      className={`font-normal ${
                        !i == 0 ? "text-[#7E7E7E]" : ""
                      }`}
                    >
                      <Link to={item.link}>
                        {!i == 0 ? item.name : item.name.toLocaleUpperCase()}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        ))}
      </div>
    </footer>
  );
};

export default Footer;
