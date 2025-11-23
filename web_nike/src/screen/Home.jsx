import Layout from "../layout/Layout";
import Link from "../components/home/Link";
import Banner from "../components/home/Banner";
import SliderProduct from "../components/home/SliderProduct";

const Home = () => {
  return (
    <Layout>
      <Link />
      <Banner />
      <SliderProduct />
    </Layout>
  );
};

export default Home;
