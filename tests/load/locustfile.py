from locust import HttpUser, between, task


class ApodUser(HttpUser):
    wait_time = between(1, 3)

    @task
    def get_apod(self):
        # Hits the main endpoint
        self.client.get("/v1/apod?date=2023-01-01")

    @task(3)
    def get_thumbs_apod(self):
        # Hits the endpoint with thumbs=true (weighted 3x more often)
        self.client.get("/v1/apod?date=2026-01-01&thumbs=true")

    @task(5)
    def get_today_apod(self):
        # Hits the endpoint with no date specified (weighted 5x more often)
        self.client.get("/v1/apod")
