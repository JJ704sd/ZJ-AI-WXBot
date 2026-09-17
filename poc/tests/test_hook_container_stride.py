import pytest
from scripts.audit_hook_container_stride import exact_multiple_stride


@pytest.mark.parametrize('odd,shift', [(3, 0), (91, 3), (93, 3), (127, 4)])
def test_recovers_stride_for_exact_multiples(odd, shift):
    magic = pow(odd, -1, 1 << 64)
    stride = exact_multiple_stride(magic, shift)
    assert stride == odd << shift
    for count in (0, 1, 17, 65535, 1000000):
        assert (((count * stride) >> shift) * magic) % (1 << 64) == count


@pytest.mark.parametrize('multiplier,shift', [(0,3),(2,3),(-1,3),(1<<64,3),(3,-1),(3,64)])
def test_invalid_arithmetic_rejected(multiplier, shift):
    with pytest.raises(ValueError):
        exact_multiple_stride(multiplier, shift)
