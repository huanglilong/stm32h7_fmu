fmu_add_module(
	MODULE modules__hello_nuttx
	MAIN hello_nuttx
	SRCS
    hello_nuttx_main.cc
		hello_nuttx.cc
    hello_nuttx.h
	DEPENDS
    nuttx_sched nuttx_drivers nuttx_boards nuttx_c nuttx_mm nuttx_arch nuttx_xx nuttx_apps nuttx_fs nuttx_binfmt
)
