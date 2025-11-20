<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    public function update(Request $request, $id) 
    {
        $data = $request->validate([
            'role' => 'nullable'
        ]);

        $user = User::findOrFail($id);
        $user->update($data);

        return redirect()->route('customer');
    }
}