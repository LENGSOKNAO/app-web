<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Products extends Model
{
    protected $table = 'products';

    protected $fillable = [
        'name',
        'description',
        'is_active',
        'new_arrival'
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'new_arrival' => 'boolean'
    ];

    public function brand():  HasMany
    {
        return $this->hasMany(Brand::class, 'products_id');
    }

    public function category():  HasMany
    {
        return $this->hasMany(Categories::class, 'products_id');
    }

    public function coupons():  HasMany
    {
        return $this->hasMany(Coupons::class, 'products_id');
    }

    public function varants():  HasMany
    {
        return $this->hasMany(ProductVarants::class, 'products_id');
    }

    public function tax():  HasMany
    {
        return $this->hasMany(Tax::class, 'products_id');
    }

    public function order(): HasMany
    {
        return $this->hasMany(OrdersItems::class, 'products_id');
    }
    
    public function wishlist(): HasMany
    {
        return $this->hasMany(Wishlist::class, 'products_id');
    }
}
