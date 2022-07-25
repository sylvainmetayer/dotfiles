#!/usr/bin/env bash

function k8s_get_all_resources() {
    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found
}

function k8s_get_event_sorted() {
    # https://linuxhint.com/sort-kubectl-events-by-time/
    kubectl get events --sort-by='.metadata.creationTimestamp' -A
}
