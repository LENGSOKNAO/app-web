<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;


class Orders extends Model
{
    protected $table = 'orders';

    protected $fillable = [
        'users_id',
        'total',
        'shipping_method',
        'status'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'users_id', 'id');
    }

    public function payment(): HasMany
    {
        return $this->hasMany(Payment::class, 'orders_id');
    }

    public function address(): HasMany
    {
        return $this->hasMany(Address::class, 'orders_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrdersItems::class, 'orders_id', 'id');
    }

}
