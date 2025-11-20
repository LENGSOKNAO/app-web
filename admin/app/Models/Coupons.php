<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Coupons extends Model
{
    protected $table = 'coupons';

    protected $fillable = [
        'products_id',
        'code',
        'discount_amount',
        'start_date',
        'end_date',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Products::class, 'products_id');
    }
}
