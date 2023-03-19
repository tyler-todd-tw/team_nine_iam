<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/>
		<br />
		<a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
		<br />
		<h3>lab-iam-profiles</h3>
		</a> <a href="https://app.circleci.com/pipelines/github/ThoughtWorks-DPS/lab-iam-profiles"><img src="https://circleci.com/gh/ThoughtWorks-DPS/lab-iam-profiles.svg?style=shield"></a>
		<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/lab-iam-profiles"></a>
	</p>
</div>

This iam-profiles pipeline implements a secure, single platform team identity pattern that is assumed to be part of a broader product-centered identity architecture.  

While the number of team-bounded domains in a delivery infrastructure platform will likely grow from just one (depending on the number of development teams using the platform), a essential pattern for securing the permission boundary for _Users_ of the product involves seprating such user's identity, and authentication and authorization events, from the underlying IaaS providers native infrastructure identity.  

You see this pattern repeated across the SaaS and mobile marketplace. You are experiencing it right now as you read this file on github.com. As many people are aware, github.com is hosted on rackspace.com. Since being purchased by Microsoft, many new features are being hosted on Azure. When you use those new hosted GitHub Runners, you are not personally working from an Azure identity. You created a discrete github identity (or perhaps it was created for you through your organizational SSO integration with github). Github services use this _constomer identity_ to manage the data and services to which individual users have access.  

How this relates to a delivery infrastructure platform will become more apparent if you follow along in the dps-labs series of platform repos. For now, know that in the context of IAM users and the roles assumes by IAM users, the goal is to limit kinds and numbers of IAM users to just the Platform team itself and the service accounts used by the pipelines that orchestrate the provisioning and lifecycle management of the underlying infrastructure.  

**note**: Why is this repo named `iam-profiles`? When using the AWS command-line tool to interact with Amazon Web Services, a users AWS Profile is used as a term to refer to the combination of the users AWS credentials, the particular role they wish to assume, and the AWS region to reference by default when processing user commands. Since this repo and pipeline are chiefly concerned with managing the service account identities and credentials and all the user-assumeable roles across the AWS accounts used by this delivery platform, the name iam-profiles is adopted as a team convention to identity the primary pipeline responsibilities. And it can be said that the `domain` of this pipeline is the management of IAM services accounts, and the roles that service accounts or platform developers may assume.  

#### starting point in an AWS setting

Account structure  

<div align="center">
	<p>
		<img alt="account strategy" src="https://github.com/ThoughtWorks-DPS/lab-iam-profiles/blob/main/doc/aws_account_strategy.png" />
	</p>
</div>

The `state` account is a dedicated account within which service accounts and non-federated platform delivery team members, groups, and group memberships are defined, and as an aggregation location for security audit log and other cross-account data that needs to be funneled into longer-term systems of record.  

The iam-profiles pipeline manages the creation of the service account iam user identities, the nonprod and prod iam groups, and membership attachment of iam user identites with one or both of those iam groups.  

In addition, it also manages the propogation of a common set of pipeline roles that exist in each of the platform accounts, e.g., the same set of roles exist across all the accounts. It is membership within one of the above groups that determines which accounts the iam user may assume said roles.  

The `sandbox` account is used only by the Platform team only. This account is where the continuous integration and testing of platform infrastructure takes place, prior to deployment in customer facing accounts.  

All customer, non-production workloads live in the `nonprod` account.  

The `prod` account is for customer, production workloads and for the custom, platform capability APIs.  

#### Development

_See the dependencies section below for a list of infrastructure and development services used by this implementation._  

**bootstrap step:** before a pipeline can successfully manage these resources across muiltiple accounts, the appropriate service accounts and the role used by this pipeline must already exist. How do you deal with this chicken-or-egg situation?

The only configuration that is applied to all accounts are the pipeline roles. The service account users, the group definitions, and the group memberships are all configured in a `state` account and exist only in that account. The svc account assume the necessary role from whatever account they are configuring at pipeline runtime.  

If you do not have SaaS for terraform state or secrets then the bootstrap will need to include that configuration in the state account as well.  

**what does this lab-iam-profiles pipeline manage?**

A basic example drawing below illustrates, nonprod and prod service accounts are created to act as the indentity for all infrastructure pipelines. There are matching groups defined that enable the service accounts to assume any role matching the service-account-role naming pattern in the respective aws accounts. There is also a platform team members groups created the enable the owners of these accounts to assume any role in any accounts for development and forensic purposes. _note. production access is a necessary part of product ownership, and for compliance purposes monitoring and alerts are configured for the production account to track and notify regarding platform team direct access to the production account._

These are defined in the `main.tf` resource file and are applied only if the plan is being applied to the state account. The roles are applied to all accounts in the pipeline.  

<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://github.com/ThoughtWorks-DPS/lab-iam-profiles/blob/main/doc/configuration.png" />
	</p>
</div>

This lab example simplifies the configuration to present just the resource configuration methods and uses only two accounts.  

DPS-2  (nonprod, which acts as nonprod, sandbox, and state)  
DPS-1  (prod)  

## configuration

_service accounts_

Two service accounts are created. A Nonprod service account and a Prod service account to be used for all infrastructure automation pipeline examples. In this case the example happens to have only a single type of each account, but in general the nonprod service account would be used for all nonproduction accounts of which there are typically several. The production service account is reserved for production accounts.  

DPSNonprodServiceAccount  
DPSProdServiceAccount  

_groups_

Two iam groups are created:  

DPSNonprodServiceAccountGroup  
DPSProdServiceAccountGroup  

to which the respective service accounts are added. The Nonprod service account groups is enabled to assume any role that exists in any nonproduction account, likewise the production service account can assume any role in the production account.

_roles_

A role is then created for each core infrastructure pipeline. The phrase 'core infrastructure' is used since in a kubernetes-centric architecture much of the required configuration is within kubernetes clusters themselves, which in this architecture will not use AWS identities. The result is that while many platform team pipeline will use iam identities many will not. By convention, the roles are named to reflect the pipeline that makes use of the role:  

DPS + abbrev pipeline name + Role  

examples:

arn:aws:iam::*:role/DPSIamProfilesRole  
arn:aws:iam::*:role/DPSPlatformEksBaseRole  
arn:aws:iam::*:role/DPSPlatformEksCoreServicesRole  

## DataDog

The aws account core integration to datadog is a external-id based role. This is a single role per aws account and in the lab is managed by this repo/pipeline.  

#### Dependencies

Internal developer guides and run-books for DPS lab environments are [here](https://github.com/ThoughtWorks-DPS/documentation-internal).  

*saas tools used for this pipeline
* 1password (secrets management)
* terraform cloud (backend state store)
* circleci (pipeline orchestration)
  * dockerhub (pipeline executors)
