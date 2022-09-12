push-image:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 247010350437.dkr.ecr.us-east-1.amazonaws.com
	docker build -t weather-data-on-dagster ../.
	docker tag weather-data-on-dagster:latest 247010350437.dkr.ecr.us-east-1.amazonaws.com/weather-data-on-dagster:latest
	docker push 247010350437.dkr.ecr.us-east-1.amazonaws.com/weather-data-on-dagster:latest
