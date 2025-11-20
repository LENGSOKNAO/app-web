<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;


class SliderApp extends Model
{
    protected $table = 'slider_app';

    protected $fillable = ['title', 'subtitle', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];

    public function images(): HasMany 
    {
        return $this->hasMany(Images::class, 'slider_app_id');
    }

    public function category(): HasMany 
    {
        return $this->hasMany(TypeBannerOrSlider::class, 'slider_app_id');
    }
}
