<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ListColor;
use Inertia\Inertia;

class ListColorController extends Controller
{
    public function index(){
        $color = ListColor::all();
        return response()->json($color);
    }

    public function create(){
        return Inertia::render('variants/color/color-create-new');
    }

    public function store(Request $request, ListColor $color){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        $listColor = [];

        foreach ($data['name'] as $list){
            $listColor[] = $color->create(['name' => $list]);
        }

        return redirect()->route('get_color');
    }

    public function edit(ListColor $color){
        return Inertia::render('variants/color/color-edit', ['color' => $color]);
    }

    public function update(Request $request, ListColor $color){
        $data = $request->validate([
            'name' => 'nullable'
        ]);

        foreach ($data['name'] as $new){
            if(!empty($new)){
                $color->update(['name' => $new]);
            }
        }
        return redirect()->route('get_color');
    }

    public function destroy(ListColor $color){
        $color->delete();
        return redirect()->route('get_color');
    }
}