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
import AppLayout from '@/layouts/app-layout';
import { slider } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head, router } from '@inertiajs/react';
import {
    IconChevronLeft,
    IconChevronRight,
    IconChevronsLeft,
    IconChevronsRight,
} from '@tabler/icons-react';

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
    CheckCircle,
    ChevronDown,
    Image,
    MoreHorizontal,
    XCircle,
} from 'lucide-react';
import * as React from 'react';

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
    TooltipTrigger,
} from '@/components/ui/tooltip';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Slider',
        href: slider().url,
    },
];

export type Sliders = {
    id: number;
    title: string;
    subtitle: string;
    is_active: boolean;
    date_added: string;
    category: {
        category: string[];
    };
    images: { file_path: string[] };
};

export const columns: ColumnDef<Sliders>[] = [
    {
        id: 'select',
        header: ({ table }) => (
            <Checkbox
                checked={
                    table.getIsAllPageRowsSelected() ||
                    (table.getIsSomePageRowsSelected() && 'indeterminate')
                }
                onCheckedChange={(value) =>
                    table.toggleAllPageRowsSelected(!!value)
                }
                aria-label="Select all"
            />
        ),
        cell: ({ row }) => (
            <Checkbox
                checked={row.getIsSelected()}
                onCheckedChange={(value) => row.toggleSelected(!!value)}
                aria-label="Select row"
            />
        ),
        enableSorting: false,
        enableHiding: false,
    },
    {
        accessorKey: 'title',
        header: ({ column }) => {
            return (
                <Button
                    variant="ghost"
                    onClick={() =>
                        column.toggleSorting(column.getIsSorted() === 'asc')
                    }
                >
                    Title
                    <ArrowUpDown />
                </Button>
            );
        },
        cell: ({ row }) => <div>{row.getValue('title') || 'No Title'}</div>,
    },
    {
        accessorKey: 'subtitle',
        header: () => <div className="">Subtitle</div>,
        cell: ({ row }) => (
            <div>{row.getValue('subtitle') || 'No Subtitle'}</div>
        ),
    },
    {
        accessorKey: 'category',
        header: () => <div className="">Category</div>,
        cell: ({ row }) => {
            const me = row.getValue('category') as { category: string }[];
            if (me && me.length > 0 && me[0].category === null) {
                return <div>No Type</div>;
            }
            return (
                <div className="">
                    {me != null && me?.length > 0
                        ? me.map((e) => e.category).join(', ')
                        : 'No Type'}
                </div>
            );
        },
    },
    {
        accessorKey: 'is_active',
        header: () => <div className="">Status</div>,
        cell: ({ row }) => (
            <div>{row.getValue('is_active') ? 'Active' : 'Inactive'}</div>
        ),
        filterFn: (row, id, value) => {
            // If empty, show all
            if (!value) return true;

            // Convert input string to boolean
            const filterValue = value.toLowerCase();
            if (filterValue === 'active') return row.getValue(id) === true;
            if (filterValue === 'inactive') return row.getValue(id) === false;
            return true;
        },
    },

    {
        accessorKey: 'images',
        header: () => <div className="">Images</div>,
        cell: ({ row }) => {
            const images = row.getValue('images') as { file_path: string }[];
            return (
                <div className="">
                    {images.length > 0 ? (
                        <img
                            src={`/storage/${images[0].file_path}`}
                            alt="Banner"
                            className="h-10 w-10 rounded object-cover"
                        />
                    ) : (
                        'No Images'
                    )}
                </div>
            );
        },
    },
    {
        accessorKey: 'created_at',
        header: () => <div className="">Created At</div>,
        cell: ({ row }) => {
            const date = row.getValue('created_at') as string | undefined;

            if (!date) {
                return <div>No Date</div>;
            }

            const formattedDate = new Date(date).toLocaleString('en-US', {
                year: 'numeric',
                month: 'long',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true,
            });

            return <div>{formattedDate}</div>;
        },
    },
    {
        accessorKey: 'updated_at',
        header: () => <div className="">Updated At</div>,
        cell: ({ row }) => {
            const date = row.getValue('updated_at') as string | undefined;

            if (!date) {
                return <div>No Date</div>;
            }

            const formattedDate = new Date(date).toLocaleString('en-US', {
                year: 'numeric',
                month: 'long',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true,
            });

            return <div>{formattedDate}</div>;
        },
    },
    {
        id: 'actions',
        header: () => <div className="">Action</div>,
        cell: ({ row }) => {
            const slider = row.original;
            const [open, setOpen] = React.useState(false);

            const handleDelete = () => {
                router.delete(`/slider/${slider.id}`);
                setOpen(false);
            };

            return (
                <>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Open menu</span>
                                <MoreHorizontal />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem>
                                View banner details
                            </DropdownMenuItem>
                            <DropdownMenuItem>
                                <a href={`slider/${slider.id}/edit`}>
                                    Edit Slider
                                </a>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                                className="text-red-500"
                                onClick={() => setOpen(true)}
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
                                    permanently delete your banner.
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

export default function Slider({ sliders }: { sliders: Sliders[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);

    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});

    const table = useReactTable({
        data: sliders,
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

    const filteredRows = table.getFilteredRowModel().rows;
    const totalFiltered = filteredRows.length;

    const activeCount = filteredRows.filter((r) => r.original.is_active).length;
    const inactiveCount = filteredRows.filter(
        (r) => !r.original.is_active,
    ).length;

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Banner" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="grid grid-cols-1 gap-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs sm:grid-cols-2 xl:grid-cols-3 @xl/main:grid-cols-2 @5xl/main:grid-cols-3 dark:*:data-[slot=card]:bg-card">
                    {/* Total */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Total Sliders</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {totalFiltered.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <Image className="size-4" />
                                    {totalFiltered.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                All sliders in system{' '}
                                <Image className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                Total slider campaigns
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Active */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Active</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {activeCount.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <CheckCircle className="size-4" />
                                    {activeCount.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Currently live{' '}
                                <CheckCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {totalFiltered > 0
                                    ? (
                                          (activeCount / totalFiltered) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Inactive */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Inactive</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {inactiveCount.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <XCircle className="size-4" />
                                    {inactiveCount.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Paused or expired <XCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {totalFiltered > 0
                                    ? (
                                          (inactiveCount / totalFiltered) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>
                </div>

                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 px-5 md:min-h-min dark:border-sidebar-border">
                    <div className="w-full">
                        <div className="flex items-center py-4">
                            <Input
                                placeholder="Filter title..."
                                value={
                                    (table
                                        .getColumn('is_active')
                                        ?.getFilterValue() as string) ?? ''
                                }
                                onChange={(event) =>
                                    table
                                        .getColumn('is_active')
                                        ?.setFilterValue(event.target.value)
                                }
                                className="max-w-sm"
                            />
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button
                                        variant="outline"
                                        className="ml-auto"
                                    >
                                        Columns <ChevronDown />
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent align="end">
                                    {table
                                        .getAllColumns()
                                        .filter((column) => column.getCanHide())
                                        .map((column) => {
                                            return (
                                                <DropdownMenuCheckboxItem
                                                    key={column.id}
                                                    className="capitalize"
                                                    checked={column.getIsVisible()}
                                                    onCheckedChange={(value) =>
                                                        column.toggleVisibility(
                                                            !!value,
                                                        )
                                                    }
                                                >
                                                    {column.id}
                                                </DropdownMenuCheckboxItem>
                                            );
                                        })}
                                </DropdownMenuContent>
                            </DropdownMenu>
                            <div className="lg:mx-5"></div>
                            <Tooltip>
                                <TooltipTrigger asChild>
                                    <a href="slider/create">
                                        <Button variant="outline">
                                            Add New Slider
                                        </Button>
                                    </a>
                                </TooltipTrigger>
                                <TooltipContent>
                                    <p>Add new slider</p>
                                </TooltipContent>
                            </Tooltip>
                        </div>
                        <div className="overflow-hidden rounded-md border">
                            <Table>
                                <TableHeader>
                                    {table
                                        .getHeaderGroups()
                                        .map((headerGroup) => (
                                            <TableRow key={headerGroup.id}>
                                                {headerGroup.headers.map(
                                                    (header) => {
                                                        return (
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
                                                        );
                                                    },
                                                )}
                                            </TableRow>
                                        ))}
                                </TableHeader>
                                <TableBody>
                                    {table.getRowModel().rows?.length ? (
                                        table.getRowModel().rows.map((row) => (
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
                                                            key={cell.id}
                                                        >
                                                            {flexRender(
                                                                cell.column
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
                                                No results.
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
                                                    table.getState().pagination
                                                        .pageSize
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
                                    {table.getState().pagination.pageIndex + 1}{' '}
                                    of {table.getPageCount()}
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
                        ;
                    </div>
                </div>
            </div>
        </AppLayout>
    );
}
