<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BannerController;
use App\Http\Controllers\SliderController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ListBrandController;
use App\Http\Controllers\SliderAppController;
use App\Http\Controllers\WishlistController;

Route::apiResource('banners', BannerController::class);
Route::apiResource('sliders', SliderController::class);
Route::apiResource('products', ProductController::class);
Route::apiResource('orders', OrderController::class);
Route::apiResource('list/brand', ListBrandController::class);
Route::apiResource('list/c', SliderAppController::class);
Route::apiResource('list/w', WishlistController::class);

