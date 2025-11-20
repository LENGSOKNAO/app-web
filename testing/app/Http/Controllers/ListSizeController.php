<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ListSize;
use Inertia\Inertia;

class ListSizeController extends Controller
{
    public function index(){
        $size = ListSize::all();
        return response()->json($size);
    }

    public function create(){
        return Inertia::render('variants/sizes/sizes-create-new');
    }

    public function store(Request $request, ListSize $size){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        $listSize = [];

        foreach ($data['name'] as $list){
            $listSize[] = $size->create(['name' => $list]);
        }

        return redirect()->route('get_size');
    }

    public function edit(ListSize $size){
        return Inertia::render('variants/sizes/size-edit', ['size' => $size]);
    }

    public function update(Request $request, ListSize $size){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        foreach ($data['name'] as $new){
            if(!empty($new)){
                $size->update(['name' => $new]);
            }
        }
        return redirect()->route('get_size');
    }

    public function destroy(ListSize $size){
        $size->delete();
        return redirect()->route('get_size');
    }
}
