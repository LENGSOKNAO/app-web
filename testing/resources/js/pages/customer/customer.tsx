import AppLayout from '@/layouts/app-layout';
import { customer } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head, router } from '@inertiajs/react';
import {
    IconChevronLeft,
    IconChevronRight,
    IconChevronsLeft,
    IconChevronsRight,
} from '@tabler/icons-react';
import {
    ColumnDef,
    ColumnFiltersState,
    flexRender,
    getCoreRowModel,
    getFilteredRowModel,
    getPaginationRowModel,
    getSortedRowModel,
    SortingState,
    useReactTable,
    VisibilityState,
} from '@tanstack/react-table';
import {
    ArrowUpDown,
    Check,
    ChevronDown,
    MoreHorizontal,
    Package,
    Shield,
    User,
    Users,
    X,
} from 'lucide-react';
import * as React from 'react';

import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';

import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import { Badge } from '@/components/ui/badge';
import {
    Card,
    CardAction,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card';
import { Checkbox } from '@/components/ui/checkbox';
import {
    DropdownMenu,
    DropdownMenuCheckboxItem,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table';
import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
} from '@/components/ui/tooltip';

/* -------------------------------------------------------------------------- */
/*                               BREADCRUMBS                                  */
/* -------------------------------------------------------------------------- */
const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Customers', href: customer().url },
];

/* -------------------------------------------------------------------------- */
/*                                 TYPE (REAL)                                */
/* -------------------------------------------------------------------------- */
export type Customer = {
    id: number;
    first_name: string;
    last_name: string;
    email: string;
    role: string;
    created_at: string;
    updated_at: string;
    profile: string | null; // filename only
};

/* -------------------------------------------------------------------------- */
/*                                 COLUMNS                                    */
/* -------------------------------------------------------------------------- */
export const columns: ColumnDef<Customer>[] = [
    /* ----- SELECT ----- */
    {
        id: 'select',
        header: ({ table }) => (
            <Checkbox
                checked={
                    table.getIsAllPageRowsSelected() ||
                    (table.getIsSomePageRowsSelected() && 'indeterminate')
                }
                onCheckedChange={(v) => table.toggleAllPageRowsSelected(!!v)}
                aria-label="Select all"
            />
        ),
        cell: ({ row }) => (
            <Checkbox
                checked={row.getIsSelected()}
                onCheckedChange={(v) => row.toggleSelected(!!v)}
                aria-label="Select row"
            />
        ),
        enableSorting: false,
        enableHiding: false,
    },

    /* ----- ID ----- */
    {
        accessorKey: 'id',
        header: ({ column }) => (
            <Button
                variant="ghost"
                onClick={() =>
                    column.toggleSorting(column.getIsSorted() === 'asc')
                }
            >
                ID
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => (
            <div className="font-medium">{row.getValue('id')}</div>
        ),
    },

    /* ----- AVATAR ----- */
    {
        id: 'avatar',
        header: () => <div className="text-center">Photo</div>,
        cell: ({ row }) => {
            const filename = row.original.profile;
            const imageUrl = filename ? `/storage/profiles/${filename}` : null;

            return (
                <div className="flex items-center justify-center">
                    {imageUrl ? (
                        <img
                            src={imageUrl}
                            alt={`${row.original.first_name}'s profile`}
                            className="h-10 w-10 rounded-full border object-cover"
                            onError={(e) => {
                                e.currentTarget.src =
                                    'https://ui.shadcn.com/avatars/01.png';
                            }}
                        />
                    ) : (
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-xs font-medium text-muted-foreground">
                            {row.original.first_name[0].toUpperCase()}
                            {row.original.last_name[0].toUpperCase()}
                        </div>
                    )}
                </div>
            );
        },
    },

    /* ----- NAME ----- */
    {
        accessorKey: 'first_name',
        header: () => (
            <div className="flex items-center gap-1">
                <User className="h-4 w-4" /> Name
            </div>
        ),
        cell: ({ row }) => {
            const first = row.getValue('first_name') as string;
            const last = row.original.last_name;
            return `${first} ${last}`;
        },
    },

    /* ----- EMAIL ----- */
    {
        accessorKey: 'email',
        header: () => <div>Email</div>,
        cell: ({ row }) => (
            <div className="text-sm text-muted-foreground">
                {row.getValue('email')}
            </div>
        ),
    },

    /* ----- ROLE (EDITABLE) ----- */
    {
        accessorKey: 'role',
        header: () => (
            <div className="flex items-center gap-1">
                <Package className="h-4 w-4" /> Role
            </div>
        ),
        cell: ({ row }) => {
            const customer = row.original;
            const [editing, setEditing] = React.useState(false);
            const [value, setValue] = React.useState(customer.role);
            const original = customer.role;

            const options = ['customer', 'admin'];

            const handleSave = () => {
                const formData = new FormData();
                formData.append('role', value);
                formData.append('_method', 'PUT');

                router.post(`/customer/${customer.id}`, formData, {
                    onFinish: () => setEditing(false),
                    onError: (errors) => {
                        console.error(errors);
                        setValue(original);
                        setEditing(false);
                        alert('Update failed');
                    },
                });
            };

            const color =
                value === 'admin'
                    ? 'text-red-600 font-semibold'
                    : 'text-blue-600 font-semibold';

            if (!editing) {
                return (
                    <Button
                        variant="ghost"
                        size="sm"
                        className={`h-7 px-2 text-xs ${color}`}
                        onClick={() => setEditing(true)}
                    >
                        {value || '—'}
                    </Button>
                );
            }

            return (
                <div className="flex items-center gap-1">
                    <Select value={value} onValueChange={setValue}>
                        <SelectTrigger className="h-8 w-28 text-xs">
                            <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                            {options.map((opt) => (
                                <SelectItem key={opt} value={opt}>
                                    {opt}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>

                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={handleSave}
                    >
                        <Check className="h-4 w-4 text-green-600" />
                    </Button>

                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={() => {
                            setValue(original);
                            setEditing(false);
                        }}
                    >
                        <X className="h-4 w-4 text-red-600" />
                    </Button>
                </div>
            );
        },
    },

    /* ----- CREATED AT ----- */
    {
        accessorKey: 'created_at',
        header: ({ column }) => (
            <Button
                variant="ghost"
                onClick={() =>
                    column.toggleSorting(column.getIsSorted() === 'asc')
                }
            >
                Joined
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const date = new Date(row.getValue('created_at') as string);
            return date.toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
            });
        },
    },

    /* ----- ACTIONS ----- */
    {
        id: 'actions',
        header: () => <div className="">Action</div>,
        cell: ({ row }) => {
            const customer = row.original;
            const [open, setOpen] = React.useState(false);

            const handleDelete = () => {
                router.delete(`/delete-account/${customer.id}`);
                setOpen(false);
            };

            return (
                <>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Open menu</span>
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>

                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                                className="text-red-600 focus:text-red-600"
                                onSelect={() => setOpen(true)}
                            >
                                Delete
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>

                    <AlertDialog open={open} onOpenChange={setOpen}>
                        <AlertDialogContent>
                            <AlertDialogHeader>
                                <AlertDialogTitle>
                                    Are you absolutely sure?
                                </AlertDialogTitle>
                                <AlertDialogDescription>
                                    This action cannot be undone. This will
                                    permanently delete the customer.
                                </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                                <AlertDialogCancel>Cancel</AlertDialogCancel>
                                <AlertDialogAction onClick={handleDelete}>
                                    Continue
                                </AlertDialogAction>
                            </AlertDialogFooter>
                        </AlertDialogContent>
                    </AlertDialog>
                </>
            );
        },
    },
];

/* -------------------------------------------------------------------------- */
/*                               MAIN COMPONENT                               */
/* -------------------------------------------------------------------------- */
export default function CustomerPage({ user }: { user: Customer[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);
    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});

    const table = useReactTable({
        data: user,
        columns,
        onSortingChange: setSorting,
        onColumnFiltersChange: setColumnFilters,
        getCoreRowModel: getCoreRowModel(),
        getPaginationRowModel: getPaginationRowModel(),
        getSortedRowModel: getSortedRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: setRowSelection,
        state: {
            sorting,
            columnFilters,
            columnVisibility,
            rowSelection,
        },
    });

    const totalUsers = user.length;
    const adminCount = user.filter((u) => u.role === 'admin').length;
    const customerCount = user.filter((u) => u.role === 'customer').length;

    return (
        <TooltipProvider>
            <AppLayout breadcrumbs={breadcrumbs}>
                <Head title="Customers" />

                <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                    {/* ---------- STAT CARDS ---------- */}
                    <div className="grid grid-cols-1 gap-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs sm:grid-cols-2 xl:grid-cols-3 @xl/main:grid-cols-2 @5xl/main:grid-cols-3 dark:*:data-[slot=card]:bg-card">
                        {/* Total */}
                        <Card className="@container/card">
                            <CardHeader>
                                <CardDescription>Total Users</CardDescription>
                                <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                    {totalUsers.toLocaleString()}
                                </CardTitle>
                                <CardAction>
                                    <Badge variant="outline">
                                        <Users className="size-4" />
                                        {totalUsers.toLocaleString()}
                                    </Badge>
                                </CardAction>
                            </CardHeader>
                            <CardFooter className="flex-col items-start gap-1.5 text-sm">
                                <div className="line-clamp-1 flex gap-2 font-medium">
                                    All users in system{' '}
                                    <Users className="size-4" />
                                </div>
                                <div className="text-muted-foreground">
                                    Total registered users
                                </div>
                            </CardFooter>
                        </Card>

                        {/* Admins */}
                        <Card className="@container/card">
                            <CardHeader>
                                <CardDescription>Admins</CardDescription>
                                <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                    {adminCount.toLocaleString()}
                                </CardTitle>
                                <CardAction>
                                    <Badge variant="outline">
                                        <Shield className="size-4" />
                                        {adminCount.toLocaleString()}
                                    </Badge>
                                </CardAction>
                            </CardHeader>
                            <CardFooter className="flex-col items-start gap-1.5 text-sm">
                                <div className="line-clamp-1 flex gap-2 font-medium">
                                    Users with admin privileges{' '}
                                    <Shield className="size-4" />
                                </div>
                                <div className="text-muted-foreground">
                                    {totalUsers > 0
                                        ? (
                                              (adminCount / totalUsers) *
                                              100
                                          ).toFixed(1)
                                        : 0}
                                    % of total
                                </div>
                            </CardFooter>
                        </Card>

                        {/* Customers */}
                        <Card className="@container/card">
                            <CardHeader>
                                <CardDescription>Customers</CardDescription>
                                <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                    {customerCount.toLocaleString()}
                                </CardTitle>
                                <CardAction>
                                    <Badge variant="outline">
                                        <User className="size-4" />
                                        {customerCount.toLocaleString()}
                                    </Badge>
                                </CardAction>
                            </CardHeader>
                            <CardFooter className="flex-col items-start gap-1.5 text-sm">
                                <div className="line-clamp-1 flex gap-2 font-medium">
                                    Regular customers{' '}
                                    <User className="size-4" />
                                </div>
                                <div className="text-muted-foreground">
                                    {totalUsers > 0
                                        ? (
                                              (customerCount / totalUsers) *
                                              100
                                          ).toFixed(1)
                                        : 0}
                                    % of total
                                </div>
                            </CardFooter>
                        </Card>
                    </div>

                    {/* ---------- TABLE ---------- */}
                    <div className="relative flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 px-5 dark:border-sidebar-border">
                        <div className="w-full">
                            {/* FILTER + COLUMN TOGGLE + ADD BUTTON */}
                            <div className="flex flex-col gap-4 py-4 sm:flex-row sm:items-center sm:justify-between">
                                <Input
                                    placeholder="Search name..."
                                    value={
                                        (table
                                            .getColumn('first_name')
                                            ?.getFilterValue() as string) ?? ''
                                    }
                                    onChange={(e) => {
                                        const val = e.target.value;
                                        table
                                            .getColumn('first_name')
                                            ?.setFilterValue(val);
                                    }}
                                    className="max-w-sm"
                                />

                                <div className="flex gap-2">
                                    <DropdownMenu>
                                        <DropdownMenuTrigger asChild>
                                            <Button variant="outline">
                                                Columns{' '}
                                                <ChevronDown className="ml-2 h-4 w-4" />
                                            </Button>
                                        </DropdownMenuTrigger>
                                        <DropdownMenuContent align="end">
                                            {table
                                                .getAllColumns()
                                                .filter((c) => c.getCanHide())
                                                .map((c) => (
                                                    <DropdownMenuCheckboxItem
                                                        key={c.id}
                                                        className="capitalize"
                                                        checked={c.getIsVisible()}
                                                        onCheckedChange={(v) =>
                                                            c.toggleVisibility(
                                                                !!v,
                                                            )
                                                        }
                                                    >
                                                        {c.id === 'select'
                                                            ? 'Select'
                                                            : c.id}
                                                    </DropdownMenuCheckboxItem>
                                                ))}
                                        </DropdownMenuContent>
                                    </DropdownMenu>

                                    <Tooltip>
                                        <TooltipTrigger asChild>
                                            <Button variant="outline" asChild>
                                                <a href="/register">
                                                    Add New Customer
                                                </a>
                                            </Button>
                                        </TooltipTrigger>
                                        <TooltipContent>
                                            <p>Create a new customer</p>
                                        </TooltipContent>
                                    </Tooltip>
                                </div>
                            </div>
                            {/* TABLE */}
                            <div className="rounded-md border">
                                <Table>
                                    <TableHeader>
                                        {table
                                            .getHeaderGroups()
                                            .map((headerGroup) => (
                                                <TableRow key={headerGroup.id}>
                                                    {headerGroup.headers.map(
                                                        (header) => (
                                                            <TableHead
                                                                key={header.id}
                                                            >
                                                                {header.isPlaceholder
                                                                    ? null
                                                                    : flexRender(
                                                                          header
                                                                              .column
                                                                              .columnDef
                                                                              .header,
                                                                          header.getContext(),
                                                                      )}
                                                            </TableHead>
                                                        ),
                                                    )}
                                                </TableRow>
                                            ))}
                                    </TableHeader>

                                    <TableBody>
                                        {table.getRowModel().rows?.length ? (
                                            table
                                                .getRowModel()
                                                .rows.map((row) => (
                                                    <TableRow
                                                        key={row.id}
                                                        data-state={
                                                            row.getIsSelected() &&
                                                            'selected'
                                                        }
                                                    >
                                                        {row
                                                            .getVisibleCells()
                                                            .map((cell) => (
                                                                <TableCell
                                                                    key={
                                                                        cell.id
                                                                    }
                                                                >
                                                                    {flexRender(
                                                                        cell
                                                                            .column
                                                                            .columnDef
                                                                            .cell,
                                                                        cell.getContext(),
                                                                    )}
                                                                </TableCell>
                                                            ))}
                                                    </TableRow>
                                                ))
                                        ) : (
                                            <TableRow>
                                                <TableCell
                                                    colSpan={columns.length}
                                                    className="h-24 text-center"
                                                >
                                                    No customers found.
                                                </TableCell>
                                            </TableRow>
                                        )}
                                    </TableBody>
                                </Table>
                            </div>
                            <div className="flex items-center justify-between px-6 py-4">
                                <div className="hidden flex-1 text-sm text-muted-foreground lg:flex">
                                    {
                                        table.getFilteredSelectedRowModel().rows
                                            .length
                                    }{' '}
                                    of {table.getFilteredRowModel().rows.length}{' '}
                                    row(s) selected.
                                </div>
                                <div className="flex w-full items-center gap-8 lg:w-fit">
                                    <div className="hidden items-center gap-2 lg:flex">
                                        <Label
                                            htmlFor="rows-per-page"
                                            className="text-sm font-medium"
                                        >
                                            Rows per page
                                        </Label>
                                        <Select
                                            value={`${table.getState().pagination.pageSize}`}
                                            onValueChange={(value) => {
                                                table.setPageSize(
                                                    Number(value),
                                                );
                                            }}
                                        >
                                            <SelectTrigger
                                                size="sm"
                                                className="w-20"
                                                id="rows-per-page"
                                            >
                                                <SelectValue
                                                    placeholder={
                                                        table.getState()
                                                            .pagination.pageSize
                                                    }
                                                />
                                            </SelectTrigger>
                                            <SelectContent side="top">
                                                {[10, 20, 30, 40, 50].map(
                                                    (pageSize) => (
                                                        <SelectItem
                                                            key={pageSize}
                                                            value={`${pageSize}`}
                                                        >
                                                            {pageSize}
                                                        </SelectItem>
                                                    ),
                                                )}
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <div className="flex w-fit items-center justify-center text-sm font-medium">
                                        Page{' '}
                                        {table.getState().pagination.pageIndex +
                                            1}{' '}
                                        of {table.getPageCount()}
                                    </div>
                                    <div className="ml-auto flex items-center gap-2 lg:ml-0">
                                        <Button
                                            variant="outline"
                                            className="hidden h-8 w-8 p-0 lg:flex"
                                            onClick={() =>
                                                table.setPageIndex(0)
                                            }
                                            disabled={
                                                !table.getCanPreviousPage()
                                            }
                                        >
                                            <span className="sr-only">
                                                Go to first page
                                            </span>
                                            <IconChevronsLeft />
                                        </Button>
                                        <Button
                                            variant="outline"
                                            className="size-8"
                                            size="icon"
                                            onClick={() => table.previousPage()}
                                            disabled={
                                                !table.getCanPreviousPage()
                                            }
                                        >
                                            <span className="sr-only">
                                                Go to previous page
                                            </span>
                                            <IconChevronLeft />
                                        </Button>
                                        <Button
                                            variant="outline"
                                            className="size-8"
                                            size="icon"
                                            onClick={() => table.nextPage()}
                                            disabled={!table.getCanNextPage()}
                                        >
                                            <span className="sr-only">
                                                Go to next page
                                            </span>
                                            <IconChevronRight />
                                        </Button>
                                        <Button
                                            variant="outline"
                                            className="hidden size-8 lg:flex"
                                            size="icon"
                                            onClick={() =>
                                                table.setPageIndex(
                                                    table.getPageCount() - 1,
                                                )
                                            }
                                            disabled={!table.getCanNextPage()}
                                        >
                                            <span className="sr-only">
                                                Go to last page
                                            </span>
                                            <IconChevronsRight />
                                        </Button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </AppLayout>
        </TooltipProvider>
    );
}
