<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $table = 'payment';
    
    protected $fillable = [
        'orders_id',
        'payment_method',
        'payment_status',
        'payment_transaction_id'
    ];

    public function order(): BelongsTo
    {
        return $this->belongsTo(Orders::class, 'orders_id');
    }
}
