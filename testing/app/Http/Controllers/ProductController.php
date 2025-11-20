<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Products;
use App\Models\ListBrand;
use App\Models\ListCategroy;
use App\Models\ListSize;
use App\Models\ListColor;
use Inertia\Inertia;

class ProductController extends Controller
{

    public function index()
    {
       
        $product = Products::with('brand', 'category', 'coupons', 'varants.images', 'tax')->latest()->get();

        return response()->json($product, 200);

    }

    public function show(Products $product)
    {
            $product->load
            ([ 
                'brand',
                'category',
                'tax',
                'varants.images.subImage',
                'coupons'
            ]);

            $transformed = [
                'id' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'is_active' => $product->is_active,
                'new_arrival' => $product->new_arrival,

                // Brand & Category as arrays
                'brand_name' => $product->brand->pluck('brand_name')->toArray(),
                'category_name' => $product->category->pluck('category_name')->toArray(),

                // Tax
                'tax' => $product->tax->first()?->tax ?? '',

                // Variants
                'sizes' => $product->varants->pluck('sizes')->toArray(),
                'colors' => $product->varants->pluck('colors')->toArray(),
                'price' => $product->varants->pluck('price')->toArray(),
                'stock' => $product->varants->pluck('stock')->toArray(),

                // Main image per variant
                'image' => $product->varants->map(function ($variant) {
                    return $variant->images->first()?->image ?? '';
                })->toArray(),

                // Sub images per variant
                'sub_image' => $product->varants->map(function ($variant) {
                    return $variant->images->first()?->subImage->pluck('sub_image')->toArray() ?? [];
                })->toArray(),

                // Coupon
                'code' => $product->coupons->first()?->code ?? '',
                'discount_amount' => $product->coupons->first()?->discount_amount ?? '',
                'start_date' => $product->coupons->first()?->start_date ?? '',
                'end_date' => $product->coupons->first()?->end_date ?? '',
        ];

        return Inertia::render('product/product-details', 
            [
                'product' => $transformed,    
            ]
        );

    }


    public function create()
    {
        $brand = ListBrand::all();
        $categroy = ListCategroy::all();
        $size = ListSize::all();
        $color = ListColor::all();
        return Inertia::render('product/product-create-new',[
            'brand' => $brand,
            'categroy' => $categroy,
            'size' => $size,
            'color' => $color,
        ]);
    }

    public function store(Request $request)
    {
        $vatedated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
            'new_arrival' => 'boolean',
        ]);
        
        $product = Products::create([
            'name' => $vatedated['name'] ?? null,
            'description' => $vatedated['description'] ?? null,
            'is_active' => $vatedated['is_active'] ?? true,
            'new_arrival' => $vatedated['new_arrival'] ?? false,
        ]);

        // === BRAND ===
        $brands = $request->input('brand_name', []);    
        foreach ($brands as $brandName) {
            if (!empty($brandName)) {
                $product->brand()->create(['brand_name' => $brandName]);
            }
        }

        // === CATEGORY ===
        $categories = $request->input('category_name', []);
        foreach ($categories as $categoryName) {
            if (!empty($categoryName)) {
                $product->category()->create(['category_name' => $categoryName]);
            }
        }

        // === TAX ===
        $tax = $request->input('tax');
        if (!empty($tax)) {
            $product->tax()->create(['tax' => $tax]);
        }

        // === VARIANTS ===
        $sizes = $request->input('sizes', []);
        $colors = $request->input('colors', []);
        $price = $request->input('price', []);
        $stock = $request->input('stock', []);
        $variantCount = max(count($sizes), count($colors), count($price), count($stock));
        $images = [];
        if ($request->hasFile('image')) {
            foreach ($request->file('image') as $imageP) {
                $images[] = $imageP->store('products', 'public');
            }
        }
        for ($i = 0; $i < $variantCount; $i++) {
            $variant = $product->varants()->create([
                'sizes' => $sizes[$i] ?? null,
                'colors' => $colors[$i] ?? null,
                'price' => $price[$i] ?? 0,
                'stock' => $stock[$i] ?? 0,
            ]);

            // Main image for this variant
            if (!empty($images[$i] ?? null)) {
                $listImage = $variant->images()->create(['image' => $images[$i]]);
            } else {
                $listImage = null;
            }

            // Handle sub images for this variant
            $subImages = [];
            if ($request->hasFile("sub_image.$i")) {
                foreach ($request->file("sub_image.$i") as $subImageFile) {
                    $subImages[] = $subImageFile->store('products', 'public');
                }
            }

            // Save sub images if we have a main image
            if ($listImage) {
                foreach ($subImages as $subImgPath) {
                    if (!empty($subImgPath)) {
                        $listImage->subImage()->create(['sub_image' => $subImgPath]);
                    }
                }
            }
        }

        // === COUPON ===
        $code = $request->input('code');
        if (!empty($code)) {
            $discount_amount = $request->input('discount_amount', 0);
            $start_date = $request->input('start_date');
            $end_date = $request->input('end_date');

            $couponData = [
                'code' => $code,
                'discount_amount' => $discount_amount ?: 0,
            ];

            if (!empty($start_date)) {
                $couponData['start_date'] = $start_date;
            }

            if (!empty($end_date)) {
                $couponData['end_date'] = $end_date;
            }

            $product->coupons()->create($couponData);
        }
        
        return redirect()->route('product');
    }


    public function edit(Products $product)
    {
            $brand = ListBrand::all();
            $categroy = ListCategroy::all();
            $size = ListSize::all();
            $color = ListColor::all();

            $product->load
            ([ 
                'brand',
                'category',
                'tax',
                'varants.images.subImage',
                'coupons'
            ]);

            $transformed = [
                'id' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'is_active' => $product->is_active,
                'new_arrival' => $product->new_arrival,

                // Brand & Category as arrays
                'brand_name' => $product->brand->pluck('brand_name')->toArray(),
                'category_name' => $product->category->pluck('category_name')->toArray(),

                // Tax
                'tax' => $product->tax->first()?->tax ?? '',

                // Variants
                'sizes' => $product->varants->pluck('sizes')->toArray(),
                'colors' => $product->varants->pluck('colors')->toArray(),
                'price' => $product->varants->pluck('price')->toArray(),
                'stock' => $product->varants->pluck('stock')->toArray(),

                // Main image per variant
                'image' => $product->varants->map(function ($variant) {
                    return $variant->images->first()?->image ?? '';
                })->toArray(),

                // Sub images per variant
                'sub_image' => $product->varants->map(function ($variant) {
                    return $variant->images->first()?->subImage->pluck('sub_image')->toArray() ?? [];
                })->toArray(),

                // Coupon
                'code' => $product->coupons->first()?->code ?? '',
                'discount_amount' => $product->coupons->first()?->discount_amount ?? '',
                'start_date' => $product->coupons->first()?->start_date ?? '',
                'end_date' => $product->coupons->first()?->end_date ?? '',
        ];

            return Inertia::render('product/product-edit', [
                'product' => $transformed,     
                'brand' => $brand,
                'categroy' => $categroy,
                'size' => $size,
                'color' => $color,]);
    }

    public function update(Request $request, Products $product)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
            'new_arrival' => 'boolean',
        ]);
        
        // Update main product
        $product->update([
            'name' => $validated['name'] ?? null,
            'description' => $validated['description'] ?? null,
            'is_active' => $validated['is_active'] ?? true,
            'new_arrival' => $validated['new_arrival'] ?? false,
        ]);

        // === BRAND ===
        $product->brand()->delete();
        $brands = $request->input('brand_name', []);    
        foreach ($brands as $brandName) {
            if (!empty($brandName)) {
                $product->brand()->create(['brand_name' => $brandName]);
            }
        }

        // === CATEGORY ===
        $product->category()->delete();
        $categories = $request->input('category_name', []);
        foreach ($categories as $categoryName) {
            if (!empty($categoryName)) {
                $product->category()->create(['category_name' => $categoryName]);
            }
        }

        // === TAX ===
        $product->tax()->delete();
        $tax = $request->input('tax');
        if (!empty($tax)) {
            $product->tax()->create(['tax' => $tax]);
        }

        // === VARIANTS ===
        // Don't delete variants, update existing ones or create new ones
        $sizes = $request->input('sizes', []);
        $colors = $request->input('colors', []);
        $price = $request->input('price', []);
        $stock = $request->input('stock', []);
        $variantCount = max(count($sizes), count($colors), count($price), count($stock));
        
        // Get existing variants
        $existingVariants = $product->varants;
        
        $images = [];
        if ($request->hasFile('image')) {
            foreach ($request->file('image') as $imageP) {
                $images[] = $imageP->store('products', 'public');
            }
        }
        
        for ($i = 0; $i < $variantCount; $i++) {
            // Update existing variant or create new one
            if (isset($existingVariants[$i])) {
                $variant = $existingVariants[$i];
                $variant->update([
                    'sizes' => $sizes[$i] ?? null,
                    'colors' => $colors[$i] ?? null,
                    'price' => $price[$i] ?? 0,
                    'stock' => $stock[$i] ?? 0,
                ]);
            } else {
                $variant = $product->varants()->create([
                    'sizes' => $sizes[$i] ?? null,
                    'colors' => $colors[$i] ?? null,
                    'price' => $price[$i] ?? 0,
                    'stock' => $stock[$i] ?? 0,
                ]);
            }

            // Main image for this variant - only update if new image is provided
            if (!empty($images[$i] ?? null)) {
                // Delete old main image if exists and create new one
                $variant->images()->delete();
                $listImage = $variant->images()->create(['image' => $images[$i]]);
            } else {
                // Keep existing image
                $listImage = $variant->images()->first();
            }

            // Handle sub images for this variant - only add new ones, don't delete old
            $subImages = [];
            if ($request->hasFile("sub_image.$i")) {
                foreach ($request->file("sub_image.$i") as $subImageFile) {
                    $subImages[] = $subImageFile->store('products', 'public');
                }
            }

            // Save new sub images if we have images
            if ($listImage && !empty($subImages)) {
                foreach ($subImages as $subImgPath) {
                    if (!empty($subImgPath)) {
                        $listImage->subImage()->create(['sub_image' => $subImgPath]);
                    }
                }
            }
        }

        // === COUPON ===
        $product->coupons()->delete();
        $code = $request->input('code');
        if (!empty($code)) {
            $discount_amount = $request->input('discount_amount', 0);
            $start_date = $request->input('start_date');
            $end_date = $request->input('end_date');

            $couponData = [
                'code' => $code,
                'discount_amount' => $discount_amount ?: 0,
            ];

            if (!empty($start_date)) {
                $couponData['start_date'] = $start_date;
            }

            if (!empty($end_date)) {
                $couponData['end_date'] = $end_date;
            }

            $product->coupons()->create($couponData);
        }
        
        return redirect()->route('product');
    }

    public function destroy(Products $product) 
    {
        $product->brand()->delete();
        $product->category()->delete();
        $product->coupons()->delete();
        $product->varants()->delete();
        $product->tax()->delete();

        $product->delete();

        return redirect()->route('product');

    }
}
