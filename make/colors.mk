
COLOR ?= 1
ifneq ($(COLOR),0)
NO_COL  := \033[0m
RED     := \033[0;31m
GREEN   := \033[0;32m
BLUE    := \033[0;34m
YELLOW  := \033[0;33m
BLINK   := \033[33;5m
endif

PRETTY_PRINT ?= 1
ifneq (${PRETTY_PRINT}, 0)
PRINTFUNC=printf
else
PRINTFUNC=true
endif

# Common build print status function
define print
  @${PRINTFUNC} "$(GREEN)$(1) $(YELLOW)$(2)$(GREEN) -> $(BLUE)$(3)$(NO_COL)\n"
endef
