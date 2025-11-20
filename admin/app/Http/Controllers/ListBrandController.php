<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ListBrand;
use Inertia\Inertia;


class ListBrandController extends Controller
{
    public function index(){
        $brand = ListBrand::all();
        return response()->json($brand);
    }

    public function create(){
        return Inertia::render('variants/brand/brand-create-new');
    }

    public function store(Request $request, ListBrand $brand){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        $listBrand = [];

        foreach ($data['name'] as $list){
            $listBrand[] = $brand->create(['name' => $list]);
        }

        return redirect()->route('get_brand');
    }

    public function edit(ListBrand $brand){
        return Inertia::render('variants/brand/brand-edit',['brand' => $brand]);
    }

    public function update(Request $request, ListBrand $brand){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        foreach ($data['name'] as $new){
            if(!empty($new)){
                $brand->update(['name' => $new]);
            }
        }
        return redirect()->route('get_brand');
    }

    public function destroy(ListBrand $brand){
        $brand->delete();
        return redirect()->route('get_brand');
    }
}
