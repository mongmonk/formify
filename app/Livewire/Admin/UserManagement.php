<?php

namespace App\Livewire\Admin;

use App\Models\User;
use Livewire\Component;
use Livewire\WithPagination;

class UserManagement extends Component
{
    use WithPagination;

    public $search = '';
    public $sortBy = 'created_at';
    public $sortDir = 'DESC';
    public $perPage = 10;

    public $user_id;
    public $name;
    public $email;
    public $password;
    public $user_role;
    public $status;

    public $selected = [];
    public $selectAll = false;

    public $showFilters = false;
    public $filterRole = '';
    public $filterStatus = '';

    public $isModalOpen = false;
    public $isConfirmModalOpen = false;
    public $userIdToDelete;

    public function render()
    {
        $users = User::query()
            ->search($this->search)
            ->when($this->filterRole, fn($query, $role) => $query->where('role', $role))
            ->when($this->filterStatus !== '', fn($query) => $query->where('status', $this->filterStatus))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate($this->perPage);

        return view('livewire.admin.user-management', [
            'users' => $users,
        ]);
    }

    public function updatedSelectAll($value)
    {
        if ($value) {
            $this->selected = User::query()
                ->search($this->search)
                ->pluck('id')
                ->map(fn ($id) => (string) $id)
                ->toArray();
        } else {
            $this->selected = [];
        }
    }

    public function updatedSearch()
    {
        $this->resetPage();
    }

    public function setSortBy($sortByField)
    {
        if ($this->sortBy === $sortByField) {
            $this->sortDir = ($this->sortDir == "ASC") ? 'DESC' : "ASC";
            return;
        }

        $this->sortBy = $sortByField;
        $this->sortDir = 'DESC';
    }

    // Modal Actions
    public function openModal()
    {
        $this->resetInputFields();
        $this->isModalOpen = true;
    }

    public function openEditModal($id)
    {
        $user = User::findOrFail($id);
        $this->user_id = $id;
        $this->name = $user->name;
        $this->email = $user->email;
        $this->user_role = $user->role;
        $this->status = $user->status;
        $this->isModalOpen = true;
    }

    public function closeModal()
    {
        $this->isModalOpen = false;
        $this->resetInputFields();
    }

    private function resetInputFields()
    {
        $this->user_id = null;
        $this->name = '';
        $this->email = '';
        $this->password = '';
        $this->user_role = '';
        $this->status = true;
    }

    public function store()
    {
        $this->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $this->user_id,
            'password' => $this->user_id ? 'nullable|min:8' : 'required|min:8',
            'user_role' => 'required|in:admin,editor,user',
        ]);

        $data = [
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->user_role,
            'status' => $this->status,
        ];

        if (!$this->user_id && $this->password) {
            $data['password'] = bcrypt($this->password);
        }

        User::updateOrCreate(['id' => $this->user_id], $data);

        session()->flash('message', $this->user_id ? 'Pengguna berhasil diperbarui.' : 'Pengguna berhasil ditambahkan.');

        $this->closeModal();
    }

    // Delete Actions
    public function confirmDelete($id)
    {
        $this->userIdToDelete = $id;
        $this->isConfirmModalOpen = true;
    }

    public function deleteUser()
    {
        User::find($this->userIdToDelete)->delete();
        $this->isConfirmModalOpen = false;
        session()->flash('message', 'Pengguna berhasil dihapus.');
        $this->userIdToDelete = null;
    }
}
