import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { EmptyDescription } from '@/components/ui/empty';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import AppLayout from '@/layouts/app-layout';
import { type BreadcrumbItem } from '@/types';
import { Head, useForm } from '@inertiajs/react';
import { ImagePlus } from 'lucide-react';
import React, { useEffect, useState } from 'react';

import { cn } from '@/lib/utils';

import { Check, ChevronsUpDown, X } from 'lucide-react';

import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList,
} from '@/components/ui/command';
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from '@/components/ui/popover';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Edit Banner',
        href: 'create',
    },
];

interface Banner {
    id: number;
    title: string | null;
    subtitle: string | null;
    category: string[];
    is_active: boolean;
    images: { id: number; file_path: string }[];
}

type Categroy = {
    name: string;
};

interface Props {
    banner: Banner;
    listCategroy: Categroy[];
}

export default function BannerEdit({ listCategroy, banner }: Props) {
    const { data, setData, processing, post, errors } = useForm({
        title: banner.title ?? '',
        subtitle: banner.subtitle ?? '',
        is_active: banner.is_active,
        category: banner.category ?? [],
        images: [] as File[],
        _method: 'PUT' as const,
    });

    const [image, setImage] = useState<string[]>([]);
    const [openCategory, setOpenCategory] = useState<Record<number, boolean>>(
        {},
    );

    const listDataCategory = listCategroy.map((e: { name: string }) => ({
        value: e.name,
        label: e.name,
    }));

    const handleOpenChangeCategory = (index: number, open: boolean) => {
        setOpenCategory((prev) => ({ ...prev, [index]: open }));
    };

    const listAddCategroy = (field: 'category') => {
        setData(field, [...data[field], '']);
    };

    const deleteCategroyList = (field: 'category', index: number) => {
        setData(
            field,
            data[field].filter((_, i) => i !== index),
        );
    };

    const updateField = (field: 'category', index: number, value: string) => {
        const updated = [...data[field]];
        updated[index] = value;
        setData(field, updated);
    };

    useEffect(() => {
        if (banner?.images) {
            setImage(banner.images.map((img) => `/storage/${img.file_path}`));
        }
    }, [banner]);

    const handleChangeImage = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = Array.from(e.target.files || []);
        setData('images', file);
        const imageP = file.map((f) => URL.createObjectURL(f));
        setImage(imageP);
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        post(`/banner_app/${banner.id}`);
    };

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Edit Banner" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 md:min-h-min dark:border-sidebar-border">
                    <form
                        onSubmit={handleSubmit}
                        className="flex h-full flex-col p-5"
                    >
                        <div className="grid gap-5 sm:grid-cols-2">
                            <div className="flex flex-col">
                                <Label htmlFor="title" className="pb-5">
                                    Title
                                </Label>
                                <Input
                                    id="title"
                                    name="title"
                                    type="text"
                                    value={data.title}
                                    placeholder="Banner Title"
                                    className="h-13"
                                    onChange={(e) =>
                                        setData('title', e.target.value)
                                    }
                                ></Input>
                            </div>

                            <div className="flex flex-col">
                                <Label htmlFor="title" className="pb-5">
                                    category
                                </Label>

                                {data.category.map((value, i) => (
                                    <div
                                        key={i}
                                        className="grid w-full grid-cols-[95%_5%] pb-5"
                                    >
                                        <Popover
                                            open={openCategory[i]}
                                            onOpenChange={(open) =>
                                                handleOpenChangeCategory(
                                                    i,
                                                    open,
                                                )
                                            }
                                        >
                                            <PopoverTrigger asChild>
                                                <Button
                                                    variant="outline"
                                                    role="combobox"
                                                    aria-expanded={
                                                        openCategory[i]
                                                    }
                                                    className="h-13 w-full justify-between"
                                                >
                                                    {value
                                                        ? listDataCategory.find(
                                                              (framework) =>
                                                                  framework.value ===
                                                                  value,
                                                          )?.label
                                                        : 'Select Category...'}
                                                    <ChevronsUpDown className="opacity-50" />
                                                </Button>
                                            </PopoverTrigger>
                                            <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                                                <Command>
                                                    <CommandInput
                                                        placeholder="Search Category..."
                                                        className="h-9"
                                                    />
                                                    <CommandList>
                                                        <CommandEmpty>
                                                            No framework found.
                                                        </CommandEmpty>
                                                        <CommandGroup>
                                                            {listDataCategory.map(
                                                                (framework) => (
                                                                    <CommandItem
                                                                        key={
                                                                            framework.value
                                                                        }
                                                                        value={
                                                                            framework.value
                                                                        }
                                                                        onSelect={() => {
                                                                            updateField(
                                                                                'category',
                                                                                i,
                                                                                framework.value,
                                                                            );
                                                                            handleOpenChangeCategory(
                                                                                i,
                                                                                false,
                                                                            );
                                                                        }}
                                                                    >
                                                                        {
                                                                            framework.label
                                                                        }
                                                                        <Check
                                                                            className={cn(
                                                                                'ml-auto',
                                                                                value ===
                                                                                    framework.value
                                                                                    ? 'opacity-100'
                                                                                    : 'opacity-0',
                                                                            )}
                                                                        />
                                                                    </CommandItem>
                                                                ),
                                                            )}
                                                        </CommandGroup>
                                                    </CommandList>
                                                </Command>
                                            </PopoverContent>
                                        </Popover>
                                        {data.category.length > 1 && (
                                            <Button
                                                size="icon"
                                                className="z-10 h-13 w-13"
                                                variant="ghost"
                                                type="button"
                                                onClick={() =>
                                                    deleteCategroyList(
                                                        'category',
                                                        i,
                                                    )
                                                }
                                            >
                                                <X className="h-5 w-5" />
                                            </Button>
                                        )}
                                    </div>
                                ))}

                                <Button
                                    variant="outline"
                                    size="sm"
                                    type="button"
                                    className="w-10"
                                    onClick={() => listAddCategroy('category')}
                                >
                                    +
                                </Button>
                            </div>
                        </div>

                        <div className="my-5">
                            <Label htmlFor="subtitle">Subtitle</Label>
                            <Textarea
                                id="subtitle"
                                value={data.subtitle}
                                placeholder="Type yout subtitle here."
                                className="my-5 h-50"
                                onChange={(e) =>
                                    setData('subtitle', e.target.value)
                                }
                            ></Textarea>
                        </div>

                        <div className="flex h-full flex-1 flex-col">
                            <Label htmlFor="images" className="py-5">
                                Images
                            </Label>
                            <Label
                                htmlFor="images"
                                className="flex h-full min-w-0 items-center justify-center rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none selection:bg-primary selection:text-primary-foreground file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 md:text-sm dark:aria-invalid:ring-destructive/40"
                            >
                                <div>
                                    {image.length > 0 ? (
                                        <div className="">
                                            {image.map((e, i) => (
                                                <img
                                                    key={i}
                                                    src={String(e)}
                                                    className="rounded-sm object-cover"
                                                    alt=""
                                                />
                                            ))}
                                        </div>
                                    ) : (
                                        <div className="flex flex-col items-center justify-center text-gray-700">
                                            <ImagePlus className="h-10 w-10" />
                                            <EmptyDescription className="text-center">
                                                You can created any banners.
                                                <br /> Get started by creating
                                                your first banner.
                                            </EmptyDescription>
                                        </div>
                                    )}
                                </div>
                                <Input
                                    id="images"
                                    type="file"
                                    name="images[]"
                                    className="hidden"
                                    onChange={handleChangeImage}
                                ></Input>
                            </Label>
                        </div>

                        <div className="flex justify-end">
                            <Label className="my-5 flex items-start gap-3 rounded-lg border p-3 hover:bg-accent/50 has-[[aria-checked=true]]:border-blue-600 has-[[aria-checked=true]]:bg-blue-50 sm:w-1/2 xl:w-1/3 dark:has-[[aria-checked=true]]:border-blue-900 dark:has-[[aria-checked=true]]:bg-blue-950">
                                <Checkbox
                                    id="is_active"
                                    defaultChecked
                                    className="data-[state=checked]:border-blue-600 data-[state=checked]:bg-blue-600 data-[state=checked]:text-white dark:data-[state=checked]:border-blue-700 dark:data-[state=checked]:bg-blue-700"
                                    onCheckedChange={(e) =>
                                        setData('is_active', Boolean(e))
                                    }
                                    checked={data.is_active}
                                />
                                <div className="grid gap-1.5 font-normal">
                                    <p className="text-sm leading-none font-medium">
                                        Enable banner
                                    </p>
                                    <p className="text-sm text-muted-foreground">
                                        You can enable or disable banner at any
                                        time.
                                    </p>
                                </div>
                            </Label>
                        </div>

                        <div className="flex items-center justify-end gap-4">
                            <Button
                                disabled={processing}
                                data-test="update-profile-button"
                                className="w-[300px]"
                            >
                                Update
                            </Button>
                        </div>
                    </form>
                </div>
            </div>
        </AppLayout>
    );
}
