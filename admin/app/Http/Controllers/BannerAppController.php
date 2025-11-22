<?php

namespace App\Http\Controllers;

use App\Models\BannerApp;
use Inertia\Inertia;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\ListCategroy;

class BannerAppController extends Controller
{
    public function index()
    {
        $banners = BannerApp::with('images')->latest()->get();
        return response()->json($banners);
    }

    public function apiIndex()
    {
        $banners = BannerApp::with('images')->latest()->get();
        return response()->json($BannerApp);
    }

    public function show(BannerApp $banner)
    {
        return response()->json($banner->load('images'));
    }

    public function create(){
        $listCategroy = ListCategroy::all();
        return Inertia::render('banner/app/banner-creare-new', ['listCategroy' => $listCategroy,]);
    }

    public function store(Request $request)
    {
        // Validate basic fields
        $validated = $request->validate([
            'title' => 'nullable|string|max:255',
            'subtitle' => 'nullable|string|max:255',
            'is_active' => 'boolean',
            'images' => 'nullable',
             // can be string, array, or files
        ]);

        $banner = BannerApp::create([
            'title' => $validated['title'] ?? null,
            'subtitle' => $validated['subtitle'] ?? null,
            'is_active' => $validated['is_active'] ?? true,
        ]);

        // Handle images
        $images = $request->input('images', []);

        // Convert single string to array
        if (!is_array($images)) {
            $images = [$images];
        }

        // Add uploaded files if any
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $path = $file->store('banners', 'public');
                $images[] = $path;
            }
        }

        // Save all images
        foreach ($images as $imagePath) {
            if (!empty($imagePath)) {
                $banner->images()->create(['file_path' => $imagePath]);
            }
        }

        $category = $request->input('category', []);
        $dataBoth = count($category);
        for ($i =0; $i < $dataBoth; $i++){
            $banner->category()->create([
                'category' => $category[$i]?? null,
            ]);
        }
        
        return redirect()->route('get_banner');
    }

    public function edit(BannerApp $banner)
    {
        $banner->load('images', 'category');
        $list = [
            'id' => $banner->id,
            'title' => $banner->title,
            'subtitle' => $banner->subtitle,
            'is_active' => $banner->is_active,
            'images' => $banner->images,
            'category' => $banner->category->pluck('category')->toArray(),
        ];

        $listCategroy = ListCategroy::all();
        return inertia('banner/app/banner-edit', ['banner' => $list, 'listCategroy' => $listCategroy]);
    }

    public function update(Request $request, BannerApp $banner)
    {
        $validated = $request->validate([
            'title' => 'nullable|string|max:255',
            'subtitle' => 'nullable|string|max:255',
            'is_active' => 'boolean',
            'images' => 'nullable',  
        ]);

        $banner->update([
            'title' => $validated['title'] ?? '',
            'subtitle' => $validated['subtitle'] ?? '',
            'is_active' => $validated['is_active'] ?? '',
        ]);

        if ($request->hasFile('images')) {

            if ($banner->images && $banner->images->count() > 0) {
                foreach ($banner->images as $oldImage) {
                    if (Storage::disk('public')->exists($oldImage->file_path)) {
                        Storage::disk('public')->delete($oldImage->file_path);
                    }
                    $oldImage->delete();
                }
            }

            foreach ($request->file('images') as $file) {
                $path = $file->store('banners', 'public');
                $banner->images()->create(['file_path' => $path]);
            }
        }

        $banner->category()->delete();
        $category = $request->input('category', []);
        foreach ($category as $cat) {
            if (!empty($cat)) {
                $banner->category()->create(['category' => $cat]);
            }
        }

        return redirect()->route('get_banner');
    }

    public function destroy(BannerApp $banner)
    {
        foreach ($banner->images as $image) {
            if (Storage::disk('public')->exists($image->file_path)) {
                Storage::disk('public')->delete($image->file_path);
            }
        }

        $banner->images()->delete();

        $banner->delete();

        return redirect()->route('get_banner');
    }

}

