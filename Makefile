APP = adventofcode

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help


#
# FROM HOST SHELL
#
start:  ## Start the docker-compose containers in background
	docker-compose up -d
.PHONY: start

exec:   ## Open a shell in the docker-compose web container
	docker-compose exec -e SHELL=zsh web zsh
.PHONY: exec

end:    ## Shutdown the docker-compose contaienrs
	docker-compose down
.PHONY: end

#
# FROM CONTAINER SHELL
#
dev:  ## DEV - From container shell, Start phoenix with an iex shell
	cd ${APP}; mix test.watch
.PHONY: dev

