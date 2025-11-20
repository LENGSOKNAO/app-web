<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\SliderApp;
use Inertia\Inertia;
use App\Models\ListCategroy;

class SliderAppController extends Controller
{
 
    public function index()
    {

        $sliders = SliderApp::with('images')->latest()->get();

        return response()->json($sliders, 201);

    }

    public function show(SliderApp $slider)
    {

        return response()->json($slider->load('images'), 201);

    }

    public function create()
    {
        $listCategroy = ListCategroy::all();
        return Inertia::render('slider/app/slider-create-new-app', ['listCategroy' => $listCategroy]);
    }

    public function store(Request $request)
    {

        $slider = $request->validate([

            'title' => 'nullable|string|max:250',
            'subtitle' => 'nullable|string|max:255',
            'is_active' =>  'boolean',
            'images' => 'nullable'

        ]);

        $sliders = SliderApp::create([  
            'title' => $slider['title'] ?? null,
            'subtitle' => $slider['subtitle'] ?? null,
            'is_active' => $slider['is_active'] ?? true,
        ]);

        $images = $request->input('images', []);

        if(!is_array($images)){
            $images = [$images];
        }

        if($request->hasFile('images')){
            foreach($request->file('images') as $file){
                $path = $file->store('sliders', 'public');
                $images[] = $path;
            }
        }

        foreach($images as $imagePath){
            if(!empty($imagePath)){
                $sliders->images()->create(['file_path' => $imagePath]);
            }
        }

        $category = $request->input('category', []);
        $dataBoth = count($category);
        foreach ($category as $cat) {
            if (!empty($cat)) {
                $sliders->category()->create(['category' => $cat]);
            }
        }

        return redirect()->route('s_a');

    }

    public function edit(SliderApp $slider)
    {
        $slider->load('images', 'category');

        $list = [
            'id' => $slider->id,
            'title' => $slider->title,
            'subtitle' => $slider->subtitle,
            'is_active' => $slider->is_active,    
            'images' => $slider->images,
            'category' => $slider->category->pluck('category')->toArray(),
        ];
        $listCategroy = ListCategroy::all();

        return inertia('slider/app/slider-edit', [
            'slider' => $list, 
            'listCategroy' => $listCategroy]);
    }

    public function update(Request $request, SliderApp $slider)
    {
         
        $sliders = $request->validate([

            'title' => 'nullable|string|max:250',
            'subtitle' => 'nullable|string|max:255',
            'is_active' =>  'boolean',
            'images' => 'nullable'

        ]);

        $slider->update([
            'title' => $sliders['title'] ?? '',
            'subtitle' => $sliders['subtitle'] ?? '',
            'is_active' => $sliders['is_active'] ?? '',

        ]);


        if($request->hasFile('images')) {

            if ($slider->images && $slider->images->count() > 0) {
                foreach ($slider->images as $oldImage) {
                    if (Storage::disk('public')->exists($oldImage->file_path)) {
                        Storage::disk('public')->delete($oldImage->file_path);
                    }
                    $oldImage->delete();
                }
            }

            foreach ($request->file('images') as $file) {
                $path = $file->store('sliders', 'public');
                $slider->images()->create(['file_path' => $path]);
            }
        }

        
        $slider->category()->delete();
        $category = $request->input('category', []);
        foreach ($category as $cat) {
            if (!empty($cat)) {
                $slider->category()->create(['category' => $cat]);
            }
        }

        return redirect()->route('s_a');

    }

    public function destroy(SliderApp $slider)
    {
        foreach($slider->images as $image){
            if(Storage::disk('public')->exists($image->file_path)) {
                Storage::disk('public')->delete($image->file_path);
            }
        }

        $slider->images()->delete();

        $slider->delete();

        return redirect()->route('s_a');
    }

}