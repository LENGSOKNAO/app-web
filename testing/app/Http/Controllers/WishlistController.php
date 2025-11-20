<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Wishlist;
use App\Models\ProductVarants;
use Inertia\Inertia;

class WishlistController extends Controller
{

    public function index()
    {
        $wishlist = Wishlist::with('user', 'product', 'product.brand')->latest()->get();

        // return Inertia::render('WishlistDashboard', [
        //     'wishlist' => $wishlist,
        // ]);
        return response()->json($wishlist, 200);
    }

    public function store(Request $request)
    {

        $data = $request->validate([
            'users_id' => 'nullable',
            'products_id' => 'nullable',
        ]);

        $wishlist = Wishlist::create([
            'users_id' =>  $data['users_id'] ?? Auth::id(), 
            'products_id' => $data['products_id'] ?? null,
        ]);

        return response()->json($wishlist->load('user', 'product.brand'), 201);
    }
}
