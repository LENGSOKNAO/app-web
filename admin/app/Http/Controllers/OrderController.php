<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\Orders;
use App\Models\User;
use App\Models\ProductVarants;
use Inertia\Inertia;

class OrderController extends Controller
{
    public function index()
    {
        $order = Orders::with('user', 'address', 'payment', 'items', 'items.product')->latest()->get();
        $user = User::get();
        $stock = ProductVarants::get();

        return Inertia::render('dashboard', [
            'order' => $order,
            'user' => $user,
            'stock' => $stock,
        ]);
    }

    public function show(Orders  $order)
    {
        return Inertia::render('order/order_details', [
            'order' => $order->load('user', 'address', 'payment', 'items.product', 'items.product.brand', 'items.productVariant', 'items.productVariant.images', 'items.productVariant.images.subImage'),
        ]);
    }

    public function store(Request $request)
    {

        $data = $request->validate([
            'users_id' => 'nullable',
            'total' => 'nullable',
            'shipping_method' => 'nullable',
            'status' => 'nullable'
        ]);

        $order = Orders::create([
            'users_id' =>  $data['users_id'] ?? Auth::id(), 
            'total' => $data['total'] ?? null,
            'shipping_method' => $data['shipping_method'] ?? null,
            'status' => $data['status'] ?? null,
        ]);

        $address_line1 = $request->input('address_line1');  
        $address_line2 = $request->input('address_line2');       
        $city = $request->input('city');
        $state = $request->input('state');
        $postal_code = $request->input('postal_code');
        $country = $request->input('country');
        $order->address()->create([
            'address_line1' => $address_line1 ?? null,
            'address_line2' => $address_line2 ?? null,
            'city' => $city ?? null,   
            'postal_code' => $postal_code ?? null,   
            'country' => $country ?? null,   
            'state' => $state ?? null,   
        ]);


        $payment_method = $request->input('payment_method');       
        $payment_status = $request->input('payment_status');
        $payment_transaction_id = $request->input('payment_transaction_id');
        $order->payment()->create([
            'payment_method' => $payment_method ?? null,
            'payment_status' => $payment_status ?? null,   
            'payment_transaction_id' => $payment_transaction_id ?? null,   
        ]);

        
        $products_id = $request->input('products_id', []);       
        $product_variants_id = $request->input('product_variants_id', []);       
        $size = $request->input('size', []);       
        $color = $request->input('color', []);
        $qty = $request->input('qty', []);
        $price = $request->input('price', []);
        foreach($product_variants_id as $index => $product){
            $order->items()->create([
                'products_id' => $products_id[$index] ?? null,  
                'product_variants_id' => $product_variants_id[$index] ?? null,
                'size' => $size[$index] ?? null ,
                'color' => $color[$index] ?? null,   
                'qty' => $qty[$index] ?? null,   
                'price' => $price[$index] ?? null,   
            ]);
        }

        return response()->json($order->load('user', 'address', 'payment', 'items.product', 'items.product.brand', 'items.productVariant'), 200);
    }

    public function update(Request $request, Orders $order)
    {
        $data = $request->validate([
            'shipping_method' => 'nullable',
            'status' => 'nullable'
        ]);

        $order->update($data);

         return redirect()->route('order');
    }

    public function destroy(Orders $order)
    {
        $order->delete();
        $order->address()->delete();
        $order->payment()->delete();
        $order->items()->delete();
 
        return redirect()->route('order');
    }
}
