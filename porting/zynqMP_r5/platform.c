/*
 * Copyright (c) 2014, Mentor Graphics Corporation
 * All rights reserved.
 * Copyright (c) 2015 Xilinx, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of Mentor Graphics Corporation nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/**************************************************************************
 * FILE NAME
 *
 *       platform.c
 *
 * DESCRIPTION
 *
 *       This file is the Implementation of IPC hardware layer interface
 *       for Xilinx Zynq ZC702EVK platform.
 *
 **************************************************************************/

#include "common/hil/hil.h"

/* -- FIX ME: ipi info is to be defined -- */
struct ipi_info {
	uint32_t ipi_base_addr;
	uint32_t ipi_chn_mask;
};

/*--------------------------- Declare Functions ------------------------ */
static int _enable_interrupt(struct proc_vring *vring_hw);
static void _notify(int cpu_id, struct proc_intr *intr_info);
static int _boot_cpu(int cpu_id, unsigned int load_addr);
static void _shutdown_cpu(int cpu_id);
static void platform_isr(int vect_id, void *data);
static void _reg_ipi_after_deinit(struct proc_vring *vring_hw);

/*--------------------------- Globals ---------------------------------- */
struct hil_platform_ops proc_ops = {
	.enable_interrupt = _enable_interrupt,
	.reg_ipi_after_deinit = _reg_ipi_after_deinit,
	.notify = _notify,
	.boot_cpu = _boot_cpu,
	.shutdown_cpu = _shutdown_cpu,
};

/* Extern functions defined out from OpenAMP lib */
extern void ipi_enable_interrupt(unsigned int vector);
extern void ipi_isr(int vect_id, void *data);
extern void platform_dcache_all_flush();

/*------------------- Extern variable -----------------------------------*/
extern struct hil_proc proc_table[];
extern const int proc_table_size;

extern void ipi_register_interrupt(unsigned long ipi_base_addr,
				   unsigned int intr_mask, void *data,
				   void *ipi_handler);

void _ipi_handler(unsigned long ipi_base_addr, unsigned int intr_mask,
		  void *data)
{
	struct proc_vring *vring_hw = (struct proc_vring *)data;
	platform_dcache_all_flush();
	hil_isr(vring_hw);
}

void _ipi_handler_deinit(unsigned long ipi_base_addr, unsigned int intr_mask,
			 void *data)
{
	return;
}

int _enable_interrupt(struct proc_vring *vring_hw)
{

	struct ipi_info *chn_ipi_info =
	    (struct ipi_info *)(vring_hw->intr_info.data);

	if (vring_hw->intr_info.vect_id < 0)
		return 0;
	/* Register IPI handler */
	ipi_register_handler(chn_ipi_info->ipi_base_addr,
			     chn_ipi_info->ipi_chn_mask, vring_hw,
			     _ipi_handler);
	/* Register ISR */
	env_register_isr(vring_hw->intr_info.vect_id,
			 &(chn_ipi_info->ipi_base_addr), ipi_isr);
	/* Enable IPI interrupt */
	env_enable_interrupt(vring_hw->intr_info.vect_id,
			     vring_hw->intr_info.priority,
			     vring_hw->intr_info.trigger_type);
	return 0;
}

void _reg_ipi_after_deinit(struct proc_vring *vring_hw)
{
	struct ipi_info *chn_ipi_info =
	    (struct ipi_info *)(vring_hw->intr_info.data);
	env_disable_interrupts();
	ipi_register_handler(chn_ipi_info->ipi_base_addr,
			     chn_ipi_info->ipi_chn_mask, 0,
			     _ipi_handler_deinit);
	env_restore_interrupts();
}

void _notify(int cpu_id, struct proc_intr *intr_info)
{

	struct ipi_info *chn_ipi_info = (struct ipi_info *)(intr_info->data);
	if (chn_ipi_info == NULL)
		return;
	platform_dcache_all_flush();
	env_wmb();
	/* Trigger IPI */
	ipi_trigger(chn_ipi_info->ipi_base_addr, chn_ipi_info->ipi_chn_mask);
}

int _boot_cpu(int cpu_id, unsigned int load_addr)
{
	return -1;
}

void _shutdown_cpu(int cpu_id)
{
	return;
}

/**
 * platform_get_processor_info
 *
 * Copies the target info from the user defined data structures to
 * HIL proc  data structure.In case of remote contexts this function
 * is called with the reserved CPU ID HIL_RSVD_CPU_ID, because for
 * remotes there is only one master.
 *
 * @param proc   - HIL proc to populate
 * @param cpu_id - CPU ID
 *
 * return  - status of execution
 */
int platform_get_processor_info(struct hil_proc *proc , int cpu_id)
{
	int idx;
	for(idx = 0; idx < proc_table_size; idx++) {
		if((cpu_id == HIL_RSVD_CPU_ID) || (proc_table[idx].cpu_id == cpu_id) ) {
			env_memcpy(proc,&proc_table[idx], sizeof(struct hil_proc));
			return 0;
		}
	}
	return -1;
}

int platform_get_processor_for_fw(char *fw_name)
{
	return 1;
}
