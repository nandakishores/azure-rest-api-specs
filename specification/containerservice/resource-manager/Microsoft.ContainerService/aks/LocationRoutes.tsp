import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./CommonModels.tsp";
import "./VmSkus.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Versioning;

namespace Microsoft.ContainerService;

// =============================================================================
// Location-scoped operation groups
// =============================================================================

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Adding @armResourceOperations would inject an undesired resource-derived tag on these location-scoped operations."
interface ManagedClustersOperationGroup {
  /**
   * Contains extra metadata on the version, including supported patch versions, capabilities, available upgrades, and details on preview status of the version
   */
  @summary("Gets a list of supported Kubernetes versions in the specified subscription.")
  @tag("ManagedClusters")
  @autoRoute
  @get
  @action("kubernetesVersions")
  listKubernetesVersions is ArmProviderActionSync<
    Response = KubernetesVersionListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationResourceParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Adding @armResourceOperations would inject an undesired resource-derived tag on these location-scoped operations."
interface TrustedAccessRolesOperationGroup {
  /**
   * List supported trusted access roles.
   */
  @tag("TrustedAccess")
  @autoRoute
  @get
  @action("trustedAccessRoles")
  @list
  list is ArmProviderActionSync<
    Response = TrustedAccessRoleListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationResourceParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Adding @armResourceOperations would inject an undesired resource-derived tag on these location-scoped operations."
@added(Versions.v2026_01_02_preview)
interface ContainerServiceOperationGroup {
  /**
   * Only returns the latest version of each node image. For example there may be an AKSUbuntu-1804gen2containerd-2024.01.26, but only AKSUbuntu-1804gen2containerd-2024.02.02 is visible in this list.
   */
  @summary("Gets a list of supported NodeImage versions in the specified subscription.")
  @autoRoute
  @get
  @list
  @action("nodeImageVersions")
  listNodeImageVersions is ArmProviderActionSync<
    Response = NodeImageVersionsListResult,
    Scope = SubscriptionActionScope,
    Parameters = LocationResourceParameter
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Adding @armResourceOperations would inject an undesired resource-derived tag on these location-scoped operations."
@added(Versions.v2026_01_02_preview)
interface VmSkusOperationGroup {
  /**
   * Gets the list of VM SKUs accepted by AKS when creating node pools in a specified location. AKS will perform a best effort approach to provision the requested VM SKUs, but availability is not guaranteed.
   */
  @summary("Gets the list of VM SKUs accepted by AKS.")
  @tag("Skus")
  @autoRoute
  @get
  @list
  @action("vmSkus")
  list is ArmProviderActionSync<
    Response = VmSkusListResult,
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationResourceParameter;

      /**
       * To Include Extended Locations information or not in the response.
       */
      @query
      includeExtendedLocations?: string;
    }
  >;
}

/**
 * The list of platform component versions.
 */
@added(Versions.v2026_01_02_preview)
model PlatformComponentVersionsList {
  /**
   * The list of component versions.
   */
  @identifiers(#[])
  value?: ComponentVersions[];
}

/**
 * Versions available for a specific platform component.
 */
@added(Versions.v2026_01_02_preview)
model ComponentVersions {
  /**
   * Component name (e.g., 'core-addon-release-manager').
   */
  component?: string;

  /**
   * The list of version information for this component.
   */
  @identifiers(#[])
  versions?: VersionInfo[];
}

/**
 * Detailed information about a specific version of a platform component.
 */
@added(Versions.v2026_01_02_preview)
model VersionInfo {
  /**
   * Full version string (e.g., 'v20251220.1').
   */
  version?: string;

  /**
   * Major version for goalVersion (e.g., 'v20251220').
   */
  majorVersion?: string;

  /**
   * The date and time when this version was released.
   */
  releasedAt?: utcDateTime;

  /**
   * The date and time when this version expires. Null for the latest version (never expires); 30 days after superseded for others.
   */
  expiresAt?: utcDateTime;

  /**
   * Whether this is the latest version for the component.
   */
  isLatest?: boolean;

  /**
   * Whether the version is available for use (false if expired or reverted).
   */
  available?: boolean;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Adding @armResourceOperations would inject an undesired resource-derived tag on these location-scoped operations."
@added(Versions.v2026_01_02_preview)
interface PlatformComponentVersionsOperationGroup {
  /**
   * Gets the list of available platform component versions for the specified location.
   */
  @summary("List available platform component versions.")
  @tag("ManagedClusters")
  @autoRoute
  @action("listPlatformComponentVersions")
  listPlatformComponentVersions is ArmProviderActionSync<
    Response = PlatformComponentVersionsList,
    Scope = SubscriptionActionScope,
    Parameters = {
      ...LocationResourceParameter;

      /**
       * Filter by component name (e.g., 'core-addon-release-manager').
       */
      @query
      component?: string;
    }
  >;
}
