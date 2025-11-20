<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class BannerApp extends Model
{
    protected $table = 'banner_app';

    protected $fillable = ['title', 'subtitle', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];

    public function images(): HasMany
    {
        return $this->hasMany(Images::class, 'banner_app_id');
    }

    public function category(): HasMany
    {
        return $this->hasMany(TypeBannerOrSlider::class, 'banner_app_id');
    }
}
