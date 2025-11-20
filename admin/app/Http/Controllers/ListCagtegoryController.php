<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ListCategroy;
use Inertia\Inertia;

class ListCagtegoryController extends Controller
{
    public function index(){
        $category = ListCategroy::all();
        return response()->json($category);
    }

    public function create(){
        return Inertia::render('variants/category/category-create-new');
    }

    public function store(Request $request, ListCategroy $category){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        $listCategory = [];

        foreach ($data['name'] as $list){
            $listCategory[] = $category->create(['name' => $list]);
        }

        return redirect()->route('get_category');
    }

    public function edit(ListCategroy $category){
        return Inertia::render('variants/category/category-edit', ['category' => $category]);
    }

    public function update(Request $request, ListCategroy $category){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        foreach ($data['name'] as $new){
            if(!empty($new)){
                $category->update(['name' => $new]);
            }
        }
        return redirect()->route('get_category');
    }

    public function destroy(ListCategroy $category){
        $category->delete();
        return redirect()->route('get_category');
    }
}