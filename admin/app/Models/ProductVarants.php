<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ProductVarants extends Model
{
    protected $table = 'product_variants';

    protected $fillable = [
        'products_id',
        'price',
        'sizes',
        'colors',
        'stock',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Products::class, 'products_id');
    }

 
    public function images(): HasMany
    {
        return $this->hasMany(ProductImage::class, 'product_variants_id');
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrdersItems::class, 'product_variants_id');
    }
}
