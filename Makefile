.PHONY: generate-swiftgen-code
generate-swiftgen-code:
	mint run swiftgen config run

.PHONY: apply-swiftlint
apply-swiftlint:
	mint run swiftlint config run

