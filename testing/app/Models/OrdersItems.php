<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;


class OrdersItems extends Model
{
    protected $table = 'orders_items';

    protected $fillable = [
        'orders_id',
        'products_id',
        'product_variants_id',
        'size',
        'color',
        'qty',
        'price'
    ];

    public function order(): BelongsTo
    {
        return $this->belongsTo(Orders::class, 'orders_id');
    }
    
    public function product(): BelongsTo
    {
        return $this->belongsTo(Products::class, 'products_id');
    }
    
    public function productVariant(): BelongsTo
    {
        return $this->belongsTo(ProductVarants::class, 'product_variants_id');
    }
}
