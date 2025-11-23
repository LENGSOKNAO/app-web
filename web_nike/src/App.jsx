import React from "react";
import { Route, Routes } from "react-router-dom";
import Home from "./screen/Home.jsx";
import Shop from "./screen/shop.jsx";

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/shop" element={<Shop />} />
    </Routes>
  );
};

export default App;
