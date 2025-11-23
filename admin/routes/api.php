<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BannerAppController;
use App\Http\Controllers\SliderController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ListBrandController;
use App\Http\Controllers\SliderAppController;
use App\Http\Controllers\WishlistController;

Route::apiResource('banners', BannerAppController::class);
Route::apiResource('sliders', SliderController::class);
Route::apiResource('products', ProductController::class);
Route::apiResource('orders', OrderController::class);
Route::apiResource('list/brand', ListBrandController::class);
Route::apiResource('list/c', SliderAppController::class);
Route::apiResource('list/w', WishlistController::class);


 
Route::get('/images/{path}', function ($path) {
    // Try multiple possible locations
    $possiblePaths = [
        storage_path('app/public/' . $path),
        storage_path('app/public/products/' . $path),
        public_path('storage/' . $path),
        public_path('storage/products/' . $path),
    ];
    
    foreach ($possiblePaths as $filePath) {
        if (file_exists($filePath)) {
            $file = file_get_contents($filePath);
            $type = mime_content_type($filePath);
            
            $response = response($file, 200);
            $response->header("Content-Type", $type);
            $response->header("Cache-Control", "public, max-age=3600");
            return $response;
        }
    }
    
    return response()->json(['error' => 'Image not found: ' . $path], 404);
})->where('path', '.*');