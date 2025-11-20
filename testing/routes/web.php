<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BannerController;
use App\Http\Controllers\SliderController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ListBrandController;
use App\Http\Controllers\ListCagtegoryController;
use App\Http\Controllers\ListColorController;
use App\Http\Controllers\ListSizeController;
use App\Http\Controllers\BannerAppController;
use App\Http\Controllers\SliderAppController;
use Inertia\Inertia;
use App\Models\Banners;
use App\Models\Sliders;
use App\Models\Products;
use App\Models\Orders;
use App\Models\User;
use App\Models\ListBrand;
use App\Models\ListCategroy;
use App\Models\ListColor;
use App\Models\ListSize;
use App\Models\Coupons;
use App\Models\Tax;
use App\Models\BannerApp;
use App\Models\SliderApp;
use App\Models\Wishlist;


Route::get('/', function () {
    return Inertia::render('welcome');
})->name('home');

Route::middleware(['auth', 'verified'])->group(function () {
    
    // dashboard
    Route::get('dashboard', function () {
        return Inertia::render('dashboard');
    })->name('dashboard');
    Route::get('/dashboard', [OrderController::class, 'index'])->name('dashboard');


    // banner
    Route::get('banner', function () {
        $banners = Banners::with('images','category')->latest()->get();
        return Inertia::render('banner/web/index', ['banners' => $banners]);
    })->name('banner');
    Route::get('banner/create', [BannerController::class, 'create']);
    Route::post('/banner', [BannerController::class, 'store'])->name('banner.store');
    Route::get('banner/{banner}/edit', [BannerController::class, 'edit']);
    Route::put('banner/{banner}', [BannerController::class, 'update'])->name('banner.update');
    Route::delete('banner/{banner}', [BannerController::class, 'destroy']);


    // banner App
    Route::get('get_banner', function () {
        $bannersApp = BannerApp::with('images','category')->latest()->get();
        return Inertia::render('banner/app/index', ['banner_app' => $bannersApp]);
    })->name('get_banner');
    Route::get('get_banner/create', [BannerAppController::class, 'create']);
    Route::post('/get_banner', [BannerAppController::class, 'store'])->name('banner_app.store');
    Route::get('get_banner/{banner}/edit', [BannerAppController::class, 'edit']);
    Route::put('banner_app/{banner}', [BannerAppController::class, 'update'])->name('banner_app.update');
    Route::delete('get_banner/{banner}', [BannerAppController::class, 'destroy']);



    // slider
    Route::get('slider', function () {
        $slider = Sliders::with('images', 'category')->latest()->get();
        return Inertia::render('slider/web/index',['sliders' => $slider]);
    })->name('slider');
    Route::get('slider/create', [SliderController::class, 'create']);
    Route::post('/slider', [SliderController::class, 'store'])->name('slider.store');
    Route::get('slider/{slider}/edit', [SliderController::class, 'edit']);
    Route::put('slider/{slider}', [SliderController::class, 'update']);
    Route::delete('slider/{slider}', [SliderController::class, 'destroy']);



    // SLIDER APP
    Route::get('s_a', function () {
        $sliderApp = SliderApp::with('images', 'category')->latest()->get();
        return Inertia::render('slider/app/index', ['slider_app' => $sliderApp]);
    })->name('s_a');

    Route::get('s_a/c', [SliderAppController::class, 'create'])->name('slider_app.create');
    Route::post('/s_a', [SliderAppController::class, 'store'])->name('slider_app.store');

    Route::get('s_a/{slider}/edit', [SliderAppController::class, 'edit'])->name('slider_app.edit');
    Route::put('s_a/{slider}', [SliderAppController::class, 'update'])->name('slider_app.update');

    Route::delete('s_a/{slider}', [SliderAppController::class, 'destroy'])->name('slider_app.destroy');



    // product
    Route::get('product', function () {
        $products = Products::with('brand', 'category', 'tax', 'varants', 'varants.images', 'coupons')->latest()->get();
        return Inertia::render('product/index', ['products' => $products]);
    })->name('product');
    Route::get('product/create', [ProductController::class, 'brand']);
    Route::get('product/create', [ProductController::class, 'create']);
    Route::post('/product', [ProductController::class, 'store']);
    Route::get('product/{product}/edit', [ProductController::class, 'edit']);
    Route::put('product/{product}', [ProductController::class, 'update']);
    Route::get('product/{product}', [ProductController::class, 'show']);
    Route::delete('product/{product}', [ProductController::class, 'destroy']);




    // order
    Route::get('order', function () {
        $order = Orders::with('user', 'address', 'payment', 'items.product', 'items.product.brand', 'items.productVariant', 'items.productVariant.images')->latest()->get();
        return Inertia::render('order/order', ['order' => $order]);
    })->name('order');
    Route::put('order/{order}', [OrderController::class, 'update']);
    Route::get('order/{order}', [OrderController::class, 'show']);
    Route::delete('order/{order}', [OrderController::class, 'destroy']);





    // customer
    Route::get('customer', function () {
         $user = User::latest()->get();
        return Inertia::render('customer/customer', ['user' => $user]);
    })->name('customer');
    Route::put('/customer/{customer}', [UserController::class, 'update']);




    // color
    Route::get('get_color', function () {
        $color = ListColor::all();
        return Inertia::render('variants/color/index',['color' => $color]);
    })->name('get_color');
    Route::get('color/create', [ListColorController::class, 'create']);
    Route::post('get_color', [ListColorController::class, 'store']);
    Route::get('color/{color}/edit', [ListColorController::class, 'edit']);
    Route::put('color/{color}', [ListColorController::class, 'update']);
    Route::delete('color/{color}', [ListColorController::class, 'destroy']);

    
    
    
    // size
    Route::get('get_size', function () {
        $size = ListSize::all();
        return Inertia::render('variants/sizes/index', ['size' => $size]);
    })->name('get_size');
    Route::get('size/create', [ListSizeController::class, 'create']);
    Route::post('get_size', [ListSizeController::class, 'store']);
    Route::get('size/{size}/edit', [ListSizeController::class, 'edit']);
    Route::put('size/{size}', [ListSizeController::class, 'update']);
    Route::delete('size/{size}', [ListSizeController::class, 'destroy']);

    



    // brand
    Route::get('get_brand', function () {
        $brand = ListBrand::all();
        return Inertia::render('variants/brand/index', ['brand' => $brand]);
    })->name('get_brand');
    Route::get('brand/create', [ListBrandController::class, 'create']);
    Route::post('get_brand', [ListBrandController::class, 'store']);
    Route::get('brand/{brand}/edit', [ListBrandController::class, 'edit']);
    Route::put('brand/{brand}', [ListBrandController::class, 'update']);
    Route::delete('brand/{brand}', [ListBrandController::class, 'destroy']);




    // categries
    Route::get('get_category', function () {
        $category = ListCategroy::all();
        return Inertia::render('variants/category/index', ['category' => $category]);
    })->name('get_category');
    Route::get('category/create', [ListCagtegoryController::class, 'create']);
    Route::post('get_category', [ListCagtegoryController::class, 'store']);
    Route::get('category/{category}/edit', [ListCagtegoryController::class, 'edit']);
    Route::put('category/{category}', [ListCagtegoryController::class, 'update']);
    Route::delete('category/{category}', [ListCagtegoryController::class, 'destroy']);



    // coupons
    Route::get('get_coupons', function () {
        $coupons = Coupons::all();
        return Inertia::render('coupons/index', ['coupons' => $coupons]);
    })->name('get_coupons');



    // tax
    Route::get('get_tax', function () {
        $tax = Tax::all();
        return Inertia::render('Taxs/index', ['tax' => $tax]);
    })->name('get_tax');


    // shipping order
    Route::get('shipping', function () {
        $order = Orders::with('user', 'address', 'payment', 'items.product', 'items.product.brand')->latest()->get();
        return Inertia::render('shipping/index', ['order' => $order]);
    })->name('shipping');


    // wishlist
    Route::get('wishlist', function () {
        $wishlist = Wishlist::with('user', 'product', 'product.brand')->latest()->get();
        return Inertia::render('wishlist/index', ['wishlist' => $wishlist]);
    })->name('wishlist');
});

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';
