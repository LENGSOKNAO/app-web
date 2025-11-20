import { order } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { router } from '@inertiajs/react';
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
    Clock,
    CreditCard,
    MapPin,
    Package,
    User,
    X,
} from 'lucide-react';
import * as React from 'react';

import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import {
    DropdownMenu,
    DropdownMenuCheckboxItem,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table';
import {
    IconChevronLeft,
    IconChevronRight,
    IconChevronsLeft,
    IconChevronsRight,
} from '@tabler/icons-react';

import { Label } from '@/components/ui/label';

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Orders', href: order().url }];

export type Order = {
    id: number;
    users_id: number;
    total: string;
    shipping_method: string;
    status: string;
    created_at: string;
    updated_at: string;
    user: {
        id: number;
        first_name: string;
        last_name: string;
        email: string;
        role: string;
        profile: string | null;
    };
    address: {
        id: number;
        address_line1: string;
        address_line2: string | null;
        city: string;
        state: string;
        postal_code: string;
        country: string;
    }[];
    payment: {
        id: number;
        payment_method: string;
        payment_status: string;
        payment_transaction_id: string;
    }[];
    items: {
        id: number;
        size: string;
        color: string;
        qty: number;
        price: string;
    }[];
};

/* -------------------------------------------------------------------------- */
/*                                 COLUMNS                                    */
/* -------------------------------------------------------------------------- */
export const columns: ColumnDef<Order>[] = [
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

 

    /* ----- CUSTOMER + AVATAR ----- */
    {
        accessorKey: 'user',
        header: () => (
            <div className="flex items-center gap-1">
                <User className="h-4 w-4" /> Customer
            </div>
        ),
        cell: ({ row }) => {
            const u = row.getValue('user') as Order['user'];
            const profileUrl = u.profile
                ? `http://localhost:8000/storage/profiles/${u.profile}`
                : null;

            return (
                <div className="flex items-center gap-3">
                    {profileUrl ? (
                        <img
                            src={profileUrl}
                            alt={`${u.first_name} ${u.last_name}`}
                            className="h-10 w-10 rounded-full border object-cover"
                            onError={(e) => {
                                e.currentTarget.src = '';
                            }}
                        />
                    ) : (
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-xs font-medium">
                            {u.first_name[0].toUpperCase()}
                            {u.last_name[0].toUpperCase()}
                        </div>
                    )}
                    <div>
                        <div className="font-medium">
                            {u.first_name} {u.last_name}
                        </div>
                        <div className="text-sm text-muted-foreground">
                            {u.email}
                        </div>
                    </div>
                </div>
            );
        },
    },

    /* ----- ADDRESS ----- */
    {
        accessorKey: 'address',
        header: () => (
            <div className="flex items-center gap-1">
                <MapPin className="h-4 w-4" /> Address
            </div>
        ),
        cell: ({ row }) => {
            const addr = (row.getValue('address') as Order['address'])[0];
            if (!addr) return <span className="text-muted-foreground">—</span>;
            return (
                <div>
                    {addr.address_line1}, {addr.city}, {addr.country}
                </div>
            );
        },
    },

    /* ----- PAYMENT METHOD ----- */
    {
        accessorKey: 'payment',
        header: () => (
            <div className="flex items-center gap-1">
                <CreditCard className="h-4 w-4" /> Payment
            </div>
        ),
        cell: ({ row }) => {
            const pay = (row.getValue('payment') as Order['payment'])[0];
            if (!pay) return <span className="text-muted-foreground">—</span>;
            return (
                <div>
                    <div className="font-medium">{pay.payment_method}</div>
                    <div
                        className={
                            pay.payment_status.toLowerCase() === 'paid'
                                ? 'text-xs text-green-600'
                                : 'text-xs text-red-600'
                        }
                    >
                        {pay.payment_status}
                    </div>
                </div>
            );
        },
    },

    /* ----- SHIPPING (EDITABLE) ----- */
    {
        accessorKey: 'shipping_method',
        header: () => (
            <div className="flex items-center gap-1">
                <Package className="h-4 w-4" /> Shipping
            </div>
        ),
        cell: ({ row }) => {
            const order = row.original;
            const [editing, setEditing] = React.useState(false);
            const [value, setValue] = React.useState(order.shipping_method);
            const original = order.shipping_method;

            const options = ['Standard', 'Express', 'Overnight'] as const;

            const handleSave = () => {
                const formData = new FormData();
                formData.append('shipping_method', value);
                formData.append('_method', 'PUT');

                router.post(`/order/${order.id}`, formData, {
                    preserveState: true,
                    onFinish: () => setEditing(false),
                    onError: () => {
                        setValue(original);
                        setEditing(false);
                    },
                });
            };

            if (!editing) {
                return (
                    <Button
                        variant="ghost"
                        size="sm"
                        className="h-7 px-2 text-xs"
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

    /* ----- TOTAL AMOUNT ----- */
    {
        accessorKey: 'total',
        header: () => <div>Amount</div>,
        cell: ({ row }) => {
            const total = parseFloat(row.getValue('total') as string) || 0;
            return (
                <div className="font-bold text-green-600">
                    ${total.toFixed(2)}
                </div>
            );
        },
    },

    /* ----- ITEM COUNT ----- */
    {
        accessorKey: 'items',
        header: () => <div>Items</div>,
        cell: ({ row }) => {
            const items = row.getValue('items') as Order['items'];
            return items.reduce((sum, i) => sum + i.qty, 0);
        },
    },

    /* ----- CREATED AT ----- */
    {
        accessorKey: 'created_at',
        header: () => (
            <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" /> Created
            </div>
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
];

/* -------------------------------------------------------------------------- */
/*                               MAIN COMPONENT                               */
/* -------------------------------------------------------------------------- */
export function DataTable({ order }: { order: Order[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);
    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});
    const [globalFilter, setGlobalFilter] = React.useState('');

    const table = useReactTable({
        data: order,
        columns,
        onSortingChange: setSorting,
        onColumnFiltersChange: setColumnFilters,
        onGlobalFilterChange: setGlobalFilter,
        getCoreRowModel: getCoreRowModel(),
        getPaginationRowModel: getPaginationRowModel(),
        getSortedRowModel: getSortedRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: setRowSelection,
        globalFilterFn: 'includesString',
        state: {
            sorting,
            columnFilters,
            columnVisibility,
            rowSelection,
            globalFilter,
        },
    });

    return (
        <div className="flex h-full flex-1 flex-col gap-6 overflow-x-auto rounded-xl p-6">
            {/* ---------- TABLE ---------- */}
            <div className="rounded-xl border bg-card shadow-sm">
                <div className="flex flex-col gap-4 p-6 pb-4 md:flex-row md:items-center md:justify-between">
                    <Input
                        placeholder="Search Orders..."
                        value={globalFilter ?? ''}
                        onChange={(e) => setGlobalFilter(e.target.value)}
                        className="w-full sm:max-w-sm"
                    />
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="outline" size="sm">
                                Columns <ChevronDown className="ml-2 h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            {table
                                .getAllColumns()
                                .filter((column) => column.getCanHide())
                                .map((column) => (
                                    <DropdownMenuCheckboxItem
                                        key={column.id}
                                        className="capitalize"
                                        checked={column.getIsVisible()}
                                        onCheckedChange={(value) =>
                                            column.toggleVisibility(!!value)
                                        }
                                    >
                                        {column.id === 'user.role'
                                            ? 'Role'
                                            : column.id}
                                    </DropdownMenuCheckboxItem>
                                ))}
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>

                <div className="overflow-x-auto">
                    <Table>
                        <TableHeader>
                            {table.getHeaderGroups().map((headerGroup) => (
                                <TableRow key={headerGroup.id}>
                                    {headerGroup.headers.map((header) => (
                                        <TableHead key={header.id}>
                                            {header.isPlaceholder
                                                ? null
                                                : flexRender(
                                                      header.column.columnDef
                                                          .header,
                                                      header.getContext(),
                                                  )}
                                        </TableHead>
                                    ))}
                                </TableRow>
                            ))}
                        </TableHeader>
                        <TableBody>
                            {table.getRowModel().rows?.length ? (
                                table.getRowModel().rows.map((row) => (
                                    <TableRow
                                        key={row.id}
                                        data-state={
                                            row.getIsSelected() && 'selected'
                                        }
                                    >
                                        {row.getVisibleCells().map((cell) => (
                                            <TableCell key={cell.id}>
                                                {flexRender(
                                                    cell.column.columnDef.cell,
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
                                        No orders found.
                                    </TableCell>
                                </TableRow>
                            )}
                        </TableBody>
                    </Table>
                </div>
                <div className="flex items-center justify-between px-6 py-4">
                    <div className="hidden flex-1 text-sm text-muted-foreground lg:flex">
                        {table.getFilteredSelectedRowModel().rows.length} of{' '}
                        {table.getFilteredRowModel().rows.length} row(s)
                        selected.
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
                                    table.setPageSize(Number(value));
                                }}
                            >
                                <SelectTrigger
                                    size="sm"
                                    className="w-20"
                                    id="rows-per-page"
                                >
                                    <SelectValue
                                        placeholder={
                                            table.getState().pagination.pageSize
                                        }
                                    />
                                </SelectTrigger>
                                <SelectContent side="top">
                                    {[10, 20, 30, 40, 50].map((pageSize) => (
                                        <SelectItem
                                            key={pageSize}
                                            value={`${pageSize}`}
                                        >
                                            {pageSize}
                                        </SelectItem>
                                    ))}
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="flex w-fit items-center justify-center text-sm font-medium">
                            Page {table.getState().pagination.pageIndex + 1} of{' '}
                            {table.getPageCount()}
                        </div>
                        <div className="ml-auto flex items-center gap-2 lg:ml-0">
                            <Button
                                variant="outline"
                                className="hidden h-8 w-8 p-0 lg:flex"
                                onClick={() => table.setPageIndex(0)}
                                disabled={!table.getCanPreviousPage()}
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
                                disabled={!table.getCanPreviousPage()}
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
                                <span className="sr-only">Go to next page</span>
                                <IconChevronRight />
                            </Button>
                            <Button
                                variant="outline"
                                className="hidden size-8 lg:flex"
                                size="icon"
                                onClick={() =>
                                    table.setPageIndex(table.getPageCount() - 1)
                                }
                                disabled={!table.getCanNextPage()}
                            >
                                <span className="sr-only">Go to last page</span>
                                <IconChevronsRight />
                            </Button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
