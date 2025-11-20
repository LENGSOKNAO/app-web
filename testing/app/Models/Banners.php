<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Banners extends Model
{
    protected $table = 'banners';

    protected $fillable = ['title', 'subtitle', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];

    public function images(): HasMany
    {
        return $this->hasMany(Images::class, 'banners_id');
    }

    public function category(): HasMany
    {
        return $this->hasMany(TypeBannerOrSlider::class, 'banners_id');
    }
}
