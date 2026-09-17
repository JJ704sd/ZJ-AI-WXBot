import importlib.util
from pathlib import Path

spec = importlib.util.spec_from_file_location('structure', Path(__file__).parents[1] / 'scripts' / 'diagnose_wxauto_window.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def test_observed_qt_shell_is_blocked():
    report = {'status': 'structure_observed', 'windows': [
        {'expected_uia_class_match': False, 'expected_name_match': True,
         'children': [{'child_count': 0}]}]}
    assert module.compatibility_status(report) == 'unsupported_uia_window_class'


def test_class_match_without_semantic_controls_is_not_enough():
    report = {'status': 'structure_observed', 'windows': [
        {'expected_uia_class_match': True, 'expected_name_match': True,
         'children': [{'child_count': 0}]}]}
    assert module.compatibility_status(report) == 'semantic_controls_unavailable'


def test_missing_observation_never_passes():
    assert module.compatibility_status({}) == 'structure_unknown'


def test_version_result_has_priority_over_shell_label():
    report = {'status': 'structure_observed', 'windows': [
        {'expected_uia_class_match': False, 'version_assessment': {'status': 'missing_semantic_controls'}}]}
    assert module.compatibility_status(report) == 'missing_semantic_controls'
