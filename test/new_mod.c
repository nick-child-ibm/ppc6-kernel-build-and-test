#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/printk.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Nick Child");
MODULE_DESCRIPTION("Module to test various things");

static unsigned int buflen = 64;
module_param(buflen, uint, 0644);

static unsigned int rowsize = 16;
module_param(rowsize, uint, 0644);

static unsigned int groupsize = 8;
module_param(groupsize, uint, 0644);
static char *buff_c = NULL;
static int *buff_i = NULL;


static int __init new_init(void)
{
    int i;
    unsigned char *hex_str;

    printk(KERN_INFO "Loading Nick driver!\n");

    buff_c = kmalloc(buflen, GFP_KERNEL);
    for (i = 0; i < buflen; i++) {
        buff_c[i] = (unsigned char) i;
    }

    printk(KERN_ERR "buff is chars:\n"); 
    hex_str = kmalloc(buflen * 3, GFP_KERNEL);
    for_each_line_in_hex_dump(i, rowsize, hex_str, buflen*3, groupsize, buff_c, buflen) {
        printk(KERN_ERR "HI: %s\n", hex_str);
    }
    kfree(hex_str);

    buff_i = kmalloc(buflen * sizeof(int), GFP_KERNEL);
    for (i = 0; i < buflen; i++) {
        buff_i[i] = i + ((i+1)<< 8) + ((i+2) <<16);
    }

    printk(KERN_ERR "buff is ints:\n");
    hex_str = kmalloc(rowsize*3 -1, GFP_KERNEL);
    for_each_line_in_hex_dump(i, rowsize, hex_str, rowsize*3-1, groupsize, buff_i, buflen) {
        printk(KERN_ERR "HI: %s\n", hex_str);
    }
    kfree(hex_str);

    printk(KERN_ERR "ASCII:\n");
    hex_str = kmalloc(rowsize * 3*2, GFP_KERNEL);
    char *buff_ascii = kmalloc(buflen, GFP_KERNEL);
    for (i = 0; i < buflen; i++) {
        buff_ascii[i] = 'a' + (unsigned char) i;
    }
    hex_dump_to_buffer(buff_ascii, buflen, rowsize, groupsize,
               hex_str, rowsize*3*2, true);
    printk(KERN_ERR "%s\n", hex_str);
    kfree(buff_ascii);
    kfree(hex_str);

    return 0;
}

static void __exit new_exit(void)
{
    printk(KERN_INFO "Unloading new driver\n");
    kfree(buff_c);
}

module_init(new_init);
module_exit(new_exit);
