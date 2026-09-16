import pytest

from scripts.probe_pad_861_metadata import loopback_endpoint
from scripts.apply_pad_861_license import BUILD, parse_license


def test_server_localhost_endpoint_is_pinned_to_numeric_loopback():
    assert loopback_endpoint("http://localhost:8098/message?sessionId=test") == "http://127.0.0.1:8098/message?sessionId=test"


@pytest.mark.parametrize("endpoint", ["https://localhost:8098/message", "http://example.com:8098/message",
                                     "http://127.0.0.1:1238/message", "http://user@localhost:8098/message",
                                     "//example.com:8098/message", "http://localhost:8098/message#fragment"])
def test_endpoint_cannot_redirect_metadata_outside_local_mcp(endpoint):
    with pytest.raises(ValueError):
        loopback_endpoint(endpoint)


@pytest.mark.parametrize("field,value", [("api_flavor", "MAX"), ("build_id", "other"),
                                       ("credential_kind", "unknown"), ("value", ""),
                                       ("value", "secret\nADMIN_KEY=other")])
def test_license_rejects_wrong_product_or_config_injection_without_echoing_secret(field, value):
    raw = {"api_flavor": "legacy", "build_id": BUILD, "credential_kind": "admin_key", "value": "test-secret"}
    raw[field] = value
    with pytest.raises(ValueError) as failure:
        parse_license(raw)
    assert "test-secret" not in str(failure.value)
    assert "secret\nADMIN_KEY" not in str(failure.value)


@pytest.mark.parametrize("kind", ["admin_key", "device_key"])
def test_license_preserves_operator_credential_kind(kind):
    assert parse_license({"api_flavor": "legacy", "build_id": BUILD, "credential_kind": kind, "value": "test-secret"}) == (kind, "test-secret")
